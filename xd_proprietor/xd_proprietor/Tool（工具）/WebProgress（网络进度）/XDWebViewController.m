//
//  XDWebViewController.m
//  XD业主
//
//  Created by zc on 2017/6/24.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWebViewController.h"
#import "XDWebProgressLayer.h"


@interface XDWebViewController ()<WKUIDelegate,WKNavigationDelegate>


@property (nonatomic, strong) XDWebProgressLayer *webProgressLayer;  //  进度条


@end

@implementation XDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    [self initUI];
    
}

- (void)initUI {

    _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    _webView.height -= 64;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];

    [_webView loadRequest:request];
    
    _webProgressLayer = [[XDWebProgressLayer alloc] init];
    _webProgressLayer.frame = CGRectMake(0, 42, kScreenWidth, 2);
    
    [self.navigationController.navigationBar.layer addSublayer:_webProgressLayer];
    
    [self.view addSubview:_webView];
}



#pragma mark - WKWebViewDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [_webProgressLayer startLoad];
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_webProgressLayer finishedLoadWithError:nil];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [_webProgressLayer finishedLoadWithError:nil];
    
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}




- (void)dealloc {
    
    [_webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}
@end
