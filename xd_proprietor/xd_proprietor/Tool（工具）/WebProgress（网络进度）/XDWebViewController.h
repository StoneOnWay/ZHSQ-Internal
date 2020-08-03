//
//  XDWebViewController.h
//  XD业主
//
//  Created by zc on 2017/6/24.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface XDWebViewController : UIViewController

@property (nonatomic, strong) WKWebView *webView;
//访问的地址
@property (nonatomic, copy)  NSString* url;


@end
