//
//  Created by cfsc on 2020/5/22.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDCallCenterBusiness.h"

@implementation XDCallCenterBusiness

+ (instancetype)sharedInstance {
    static XDCallCenterBusiness *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XDCallCenterBusiness alloc] init];
    });
    return instance;
}

- (void)initialHikSdk:(InitSdkCompletion)completion {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (!loginInfo.userModel.currentDistrict.phaseId) {
        completion(NO);
        return;
    }
    [XDHTTPRequst getPosidenTokenWithPhaseId:loginInfo.userModel.currentDistrict.phaseId succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            NSString *token = res[@"result"] ? res[@"result"] :@"";
            [CloudOpenSDK initSDKWithAuthToken:token completion:^(BOOL success, NSError *error) {
                completion(success);
            }];
        } else {
            completion(NO);
        }
    } fail:^(NSError *error) {
        completion(NO);
    }];
}

- (void)startVideoPlay:(CTCPlayerView *)playView {
    [playView startloading];
    [CloudOpenSDK startRealPlayinView:playView deviceSerial:self.talkModel.deviceSerial
                            channelNo:1
                           verifyCode:self.talkModel.verifyCode
                           completion:^(BOOL succeed, NSError *error) {
        if (succeed) {
            [CloudOpenSDK closeSound];
            [playView endloading];
        } else {
//            [XDUtil showToast:error.localizedDescription];
            [XDHTTPRequst showErrorMessageWith:error];
        }
    }];
}

- (BOOL)stopRealPlay {
    // 结束预览
    return [CloudOpenSDK stopRealPlay];
}

@end
