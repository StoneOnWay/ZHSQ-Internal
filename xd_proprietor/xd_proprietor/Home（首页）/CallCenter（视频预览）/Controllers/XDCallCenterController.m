//
//  XDCallCenterController.m
//  视频预览
//
//  Created by stone on 8/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDCallCenterController.h"
#import "CTCPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "XDSoundVibrate.h"
#import "XDCallCenterBusiness.h"

@interface XDCallCenterController ()
@property (weak, nonatomic) IBOutlet CTCPlayerView *playView;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *rejectView;
@property (weak, nonatomic) IBOutlet UIButton *hungUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *hungUpLabel;
@property (nonatomic, strong) XDCallCenterBusiness *callCenterBusiness;

@property (assign, nonatomic, getter=isTalking) BOOL talking;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) dispatch_source_t timer;

@end

@implementation XDCallCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 播放铃声
    [[XDSoundVibrate shareXDSoundVibrate] playAlertSoundWithSourcePath:@"sound_phone.caf" isCyclic:YES];
    // 获取权限
    [self getAudioPermission];
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveAction:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundAction:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

// 前台
- (void)applicationDidBecomeActiveAction:(NSNotificationCenter *)notification {
    [self.callCenterBusiness startVideoPlay:self.playView];
    [self startListenTask];
}

// 后台
- (void)applicationDidEnterBackgroundAction:(NSNotificationCenter *)notification {
    [self.callCenterBusiness stopRealPlay];
    [self endListenTask];
    if (self.isTalking) {
        [CloudOpenSDK stopVisualTalk:nil]; // 设备主动挂断时需关闭对讲
        self.talking = NO;
        [self hungUpAction:nil];
    }
}

- (void)initData {
    self.callCenterBusiness = [XDCallCenterBusiness sharedInstance];
    self.talking = NO;
    // 1.创建队列
    self.operationQueue = [[NSOperationQueue alloc] init];
    
//    [self modifyCallStatus:CloudDeviceCallStatusNoCall];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.callCenterBusiness startVideoPlay:self.playView];
    // 启动状态监听,采用轮询方式
    [self startListenTask];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.callCenterBusiness stopRealPlay];
    [[XDSoundVibrate shareXDSoundVibrate] stopAlertSound];
    [self endListenTask];
    if (self.isTalking) {
        [CloudOpenSDK stopVisualTalk:nil]; // 设备主动挂断时需关闭对讲
        self.talking = NO;
        [self hungUpAction:nil];
    }
}

- (IBAction)answerAction:(id)sender {
    [[XDSoundVibrate shareXDSoundVibrate] stopAlertSound];
    [CloudOpenSDK answer:self.callCenterBusiness.talkModel completion:^(BOOL succeed, NSError *error) {
        if (succeed) {
            [CloudOpenSDK startVisualTalk:self.callCenterBusiness.talkModel.deviceSerial
                                channelNo:1
                               verifyCode:self.callCenterBusiness.talkModel.verifyCode
                               completion:^(BOOL succeed, NSError *error) {
                                   if(succeed) {
                                       self.talking = YES;
                                   } else {
//                                       [XDUtil showToast:error.localizedDescription];
                                       [XDHTTPRequst showErrorMessageWith:error];
                                   }
                               }];
        } else {
//            [XDUtil showToast:error.localizedDescription];
            [XDHTTPRequst showErrorMessageWith:error];
        }
    }];
}

- (IBAction)rejectAction:(id)sender {
    [[XDSoundVibrate shareXDSoundVibrate] stopAlertSound];
    [CloudOpenSDK reject:self.callCenterBusiness.talkModel completion:^(BOOL succeed, NSError *error) {
        if (!succeed) {
//            [XDUtil showToast:error.localizedDescription];
            [XDHTTPRequst showErrorMessageWith:error];
        }
    }];
}

- (IBAction)hungUpAction:(id)sender {
    [CloudOpenSDK hangUp:self.callCenterBusiness.talkModel completion:^(BOOL succeed, NSError *error) {
        if (!succeed) {
//            [XDUtil showToast:error.localizedDescription];
            [XDHTTPRequst showErrorMessageWith:error];
        }
    }];
}

- (IBAction)unlockAciton:(id)sender {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *phaseId = loginInfo.userModel.currentDistrict.phaseId;
    NSString *deviceSerial = self.callCenterBusiness.talkModel.deviceSerial;
    if (!phaseId || !deviceSerial) {
        [XDUtil showToast:@"开门失败！"];
        return;
    }
    NSDictionary *dic = @{
        @"cmd":@"open",
        @"phaseId":phaseId,
        @"deviceSerial":deviceSerial
    };
    [XDHTTPRequst hikRemoteOpenWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            [XDUtil showToast:@"门已打开"];
        } else {
            [XDUtil showToast:res[@"message"]];
        }
    } fail:^(NSError *error) {
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark -
// 通过轮询时时监听设备状态,还可以用其他方式，如消息推送
- (void)startListenTask {
    [self endListenTask];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建一个定时器（dispatch_source_t本质上还是一个OC对象）
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //设置定时器的各种属性
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0*NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(2.0*NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    //设置回调
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        //定时器需要执行的操作
        if (weakSelf.operationQueue.operationCount) return;
        // 1.创建 NSBlockOperation 对象
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf listenDeviceStatus];
        }];
        // 2.调用 start 方法开始执行操作
        [weakSelf.operationQueue addOperation:operation];
    });
    //启动定时器（默认是暂停）
    dispatch_resume(self.timer);
    
}

- (void)endListenTask {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)listenDeviceStatus {
    [CloudOpenSDK listenDeviceStatus:self.callCenterBusiness.talkModel.deviceSerial completion:^(BOOL succeed, CloudDeviceCallStatus deviceCallStatus, NSError *error) {
        if (succeed) {
            if (deviceCallStatus == CloudDeviceCallStatusNoCall) { // 无呼叫
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self modifyCallStatus:CloudDeviceCallStatusNoCall];
                    if (self.isTalking) {
                        [CloudOpenSDK stopVisualTalk:nil]; // 设备主动挂断时需关闭对讲
                        self.talking = NO;
                    }
                });
            } else if (deviceCallStatus == CloudDeviceCallStatusCalling) { // 呼叫中
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self modifyCallStatus:CloudDeviceCallStatusCalling];
                });
            } else if (deviceCallStatus == CloudDeviceCallStatusAnswering) { // 通话中
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.isTalking) {
                        [self modifyCallStatus:CloudDeviceCallStatusAnswering];
                    } else {
                        [self modifyCallStatus:CloudDeviceCallStatusNoCall];
                    }
                });
            }
        }
    }];
}

// 呼叫按钮状态
- (void)modifyCallStatus:(CloudDeviceCallStatus)status {
    if (CloudDeviceCallStatusNoCall == status) { // 无呼叫
        self.answerView.hidden = YES;
        self.rejectView.hidden = YES;
        self.hungUpBtn.hidden = YES;
        self.hungUpLabel.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    } else if (CloudDeviceCallStatusCalling == status) { // 呼叫中
        self.answerView.hidden = NO;
        self.rejectView.hidden = NO;
        self.hungUpBtn.hidden = YES;
        self.hungUpLabel.hidden = YES;
    } else { // 通话中
        self.answerView.hidden = YES;
        self.rejectView.hidden = YES;
        self.hungUpBtn.hidden = NO;
        self.hungUpLabel.hidden = NO;
    }
}

#pragma mark - Private
- (void)getAudioPermission {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
        
        switch (permissionStatus) {
            case AVAudioSessionRecordPermissionUndetermined:{
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                        // Microphone enabled code
                    }
                    else {
                        // Microphone disabled code
                    }
                }];
                break;
            }
            case AVAudioSessionRecordPermissionDenied:
                // direct to settings...
                NSLog(@"已经拒绝麦克风弹框");
                
                break;
            case AVAudioSessionRecordPermissionGranted:
                NSLog(@"已经允许麦克风弹框");
                break;
            default:
                
                break;
        }
        if(permissionStatus == AVAudioSessionRecordPermissionUndetermined) return;
    }
}

@end
