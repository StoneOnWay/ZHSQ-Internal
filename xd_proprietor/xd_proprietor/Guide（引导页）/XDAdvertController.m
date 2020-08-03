//
//  Created by cfsc on 2020/7/7.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDAdvertController.h"

@interface XDAdvertController () <JXBWebViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avertImageView;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger countDownNum;

@end

@implementation XDAdvertController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *version = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@", version];
    self.countDownNum = 3;
    [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过 %ld", (long)self.countDownNum] forState:UIControlStateNormal];
    self.skipBtn.hidden = YES;
    self.avertImageView.hidden = YES;
    self.skipBtn.layer.cornerRadius = 15.f;
    self.skipBtn.layer.masksToBounds = YES;
    
    [self getAdvertData];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)getAdvertData {
    WEAKSELF
    [XDHTTPRequst getAppAdvertImageWithDic:@{@"code":@"changfangli_app_startup_diagram"} succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            // 显示跳过按钮并倒计时
            weakSelf.avertImageView.hidden = NO;
            NSString *jumpAddress = res[@"result"][@"jumpAddress"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                [weakSelf.timer setFireDate:[NSDate distantFuture]];
                JXBWebViewController *webVC = [[JXBWebViewController alloc] initWithURLString:jumpAddress];
                webVC.delegate = weakSelf;
                [weakSelf presentViewController:webVC animated:YES completion:nil];
            }];
            [weakSelf.avertImageView addGestureRecognizer:tap];
            [weakSelf.avertImageView sd_setImageWithURL:[NSURL URLWithString:res[@"result"][@"imgResource"][@"url"]]];
            weakSelf.skipBtn.hidden = NO;
            weakSelf.timer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(countDownNumbers) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSDefaultRunLoopMode];
        } else {
            [weakSelf skipAction:nil];
        }
    } fail:^(NSError *error) {
        [weakSelf skipAction:nil];
    }];
}

- (void)countDownNumbers {
    if (self.countDownNum == 0) {
        // 进入主界面
        [self skipAction:nil];
    }
    self.countDownNum -= 1;
    [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过 %ld", (long)self.countDownNum] forState:UIControlStateNormal];
}

- (IBAction)skipAction:(id)sender {
    [self.timer invalidate];
    self.timer = nil;
    [[XDCommonBusiness shareInstance] goToRootViewController];
}

- (void)webViewControllerWillDisappear:(JXBWebViewController *)webViewController {
    [self.timer setFireDate:[NSDate distantPast]];
}

@end
