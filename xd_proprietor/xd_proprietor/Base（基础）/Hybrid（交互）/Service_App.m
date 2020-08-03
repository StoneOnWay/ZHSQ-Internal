//
//  Created by cfsc on 2020/7/29.
//  Copyright © 2020 zc. All rights reserved.
//

#import "Service_App.h"
#import <WebKit/WebKit.h>

@interface Service_App () <CustomAlertViewDelegate>

@end

@implementation Service_App

// 获取用户信息
- (NSString *)func_getUserInfo:(NSDictionary *)params {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSDictionary *dic = [loginInfo.userModel mj_keyValuesWithKeys:@[@"userID", @"name", @"nickName", @"avatarId", @"avatarResource", @"mobile", @"gender", @"birthday"]];
    NSString *jsonStr = dic.mj_JSONString;
    return jsonStr;
}

// 获取token
- (NSString *)func_getToken:(NSDictionary *)params {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *authStr = [NSString stringWithFormat:@"%@ %@", loginInfo.tokenModel.token_type, loginInfo.tokenModel.access_token];
    return authStr;
}

- (void)func_getRoomInfo:(NSDictionary *)params {
    WKWebView *webView = params[@"webView"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:params[@"id"] forKey:@"id"];
    [dic setValue:params[@"version"] forKey:@"jsRPC"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [dic setValue:@(YES) forKey:@"status"];
        [dic setValue:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@{@"key":@"returnedRoomInfo"} options:0 error:NULL] encoding:NSUTF8StringEncoding] forKey:@"result"];
        NSString *messsageJson = [dic mj_JSONString];
        NSString *callbackString = [NSString stringWithFormat:@"window.hornetBridge.onMessage(%@)", messsageJson];
        if ([[NSThread currentThread] isMainThread]) {
            [webView evaluateJavaScript:callbackString completionHandler:nil];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [webView evaluateJavaScript:callbackString completionHandler:nil];
            });
        }
    });
}

@end
