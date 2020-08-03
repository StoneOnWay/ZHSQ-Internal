//
//  Created by cfsc on 2020/7/29.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDHybridWebController.h"
#import "WKMessageHandlerDispatch.h"

@interface XDHybridWebController () <WKNavigationDelegate, WKUIDelegate>

@end

@implementation XDHybridWebController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    NSError *err = nil;
    NSData *dataFromString = [prompt dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:dataFromString options:NSJSONReadingMutableContainers error:&err];
    if (!err) {
        NSString *method = payload[@"method"];
        BOOL sync = [payload[@"sync"] boolValue];
        NSArray *array = [method componentsSeparatedByString:@"."];
        // target-action
        NSString *targetName = array[0];
        NSString *actionName = array[1];
        if (sync) {
            if ([actionName isEqualToString:@"exit"]) {
                // 退出当前网页
                [self.navigationController popViewControllerAnimated:YES];
                completionHandler(nil);
            } else if ([actionName isKindOfClass:[NSString class]] && actionName.length > 0) {
                id result = [[WKMessageHandlerDispatch sharedInstance] performTarget:targetName action:actionName params:nil shouldCacheTarget:YES];
                completionHandler(result);
            } else {
                completionHandler(nil);
            }
        } else {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:payload];
            dic[@"webView"] = webView;
            [[WKMessageHandlerDispatch sharedInstance] performTarget:targetName action:actionName params:dic shouldCacheTarget:YES];
            completionHandler(nil);
        }
    } else {
        completionHandler(nil);
    }
}

@end
