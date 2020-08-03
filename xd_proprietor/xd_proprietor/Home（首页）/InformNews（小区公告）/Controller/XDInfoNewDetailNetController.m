//
//  XDInfoNewDetailNetController.m
//  XD业主
//
//  Created by zc on 2017/6/30.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDInfoNewDetailNetController.h"
#import "XDWebProgressLayer.h"
#import "XDInfoNewsToolBar.h"
#import "XDAttachmentsListController.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@interface XDInfoNewDetailNetController ()<WKNavigationDelegate, XDInfoNewsToolBarDelegate> {
    XDInfoNewsToolBar *toolBar;
}

@property (strong, nonatomic) JXBWKWebView *webView;
@property (nonatomic, strong) XDWebProgressLayer *webProgressLayer;  // 进度条
@property (assign, nonatomic) CGFloat MaxY;

@end

@implementation XDInfoNewDetailNetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 获取内容详情
    [self getContentDetailInfo];
    // 更新阅读数
    [self updateBrowseNum];
}

- (void)getContentDetailInfo {
    [MBProgressHUD showActivityMessageInWindow:nil];
    [XDHTTPRequst getContnetDetailWithID:self.infoModel.contentID succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            self.infoModel = [XDContentInfoModel mj_objectWithKeyValues:res[@"result"]];
            // 导航栏
            [self setInformNewsDetailNavi];
            // 设置子控件
            [self setInfoSubViews];
            // 设置网页
            [self setInfoWebView];
            // 设置底部工具条
            [self setInfoToolBar];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
            [MBProgressHUD hideHUD];
        }
    } fail:^(NSError *error) {
        [XDHTTPRequst showErrorMessageWith:error];
        [MBProgressHUD hideHUD];
    }];
}

- (void)updateBrowseNum {
    [XDHTTPRequst updateContentWithID:self.infoModel.contentID field:@"browseNum" succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)setInfoWebView {
    NSURL *baseURL = [NSURL URLWithString:self.infoModel.detailUrl];
    _webView = [[JXBWKWebView alloc] initWithFrame:CGRectMake(0, self.MaxY +5, kScreenWidth, kScreenHeight-NavHeight -(self.MaxY +5) - TabbarHeight -TabbarSafeBottomMargin)];
    _webView.navigationDelegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    [_webView jxb_loadRequest:request];
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    _webProgressLayer = [[XDWebProgressLayer alloc] init];
    if ([XDUtil isIPad]) {
        _webProgressLayer.frame = CGRectMake(0, navHeight - 2, kScreenHeight, 2);
    } else {
        _webProgressLayer.frame = CGRectMake(0, 42, kScreenHeight, 2);
    }
    [self.navigationController.navigationBar.layer addSublayer:_webProgressLayer];
    [self.view addSubview:_webView];
}
    
// 设置导航栏
- (void)setInformNewsDetailNavi{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.infoModel.title;
    self.navigationItem.titleView = titleLabel;
}

- (void)setInfoSubViews {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, kScreenWidth, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.infoModel.title;
    titleLabel.font = SFont(15);
    titleLabel.textColor = RGB(79, 79, 79);
    [self.view addSubview:titleLabel];
    // 发布者名字
    CGFloat titleMaxY = CGRectGetMaxY(titleLabel.frame);
    CGFloat wigth = kScreenWidth/2 -25;
    UILabel *publisherNLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleMaxY +25, wigth, 20)];
    publisherNLabel.textAlignment = NSTextAlignmentLeft;
    publisherNLabel.text = self.infoModel.publisher;
    publisherNLabel.font = SFont(11);
    publisherNLabel.textColor = RGB(112, 167, 138);
    [self.view addSubview:publisherNLabel];
    // 发布时间
    UILabel *publisherTLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth -wigth -15, titleMaxY+25, wigth, 20)];
    publisherTLabel.textAlignment = NSTextAlignmentRight;
    publisherTLabel.text = self.infoModel.publishTime;
    publisherTLabel.font = SFont(11);
    publisherTLabel.textColor = RGB(155, 155, 155);
    [self.view addSubview:publisherTLabel];
    self.MaxY = CGRectGetMaxY(publisherNLabel.frame);
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [_webProgressLayer startLoad];
    webView.hidden = YES;
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 处理webView的宽度自适应
    NSString *js= [NSString stringWithFormat:@"changeImage(%f);function changeImage(width) {var image = document.getElementsByTagName('img');for (var i = 0; i <image.length ; i++) {var  style = getComputedStyle(image[i]);if (parseInt(style.width)>=width)  {image[i].style.width = '100%%';image[i].style.height = 'auto';}}}", kScreenWidth];
    [webView evaluateJavaScript:js completionHandler:nil];
    [_webProgressLayer finishedLoadWithError:nil];
    webView.hidden = NO;
    self.view.backgroundColor = backColor;
}

//加载失败时调用(加载内容时发生错误时)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) {
        //         [webView reloadFromOrigin];
        return;
    }
    [_webProgressLayer finishedLoadWithError:nil];
}

//导航期间发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [_webProgressLayer finishedLoadWithError:nil];
}

- (void)dealloc {
    [_webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}

// 设置底部工具条
- (void)setInfoToolBar {
    CGFloat webViewMaxY = CGRectGetMaxY(self.webView.frame);
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, webViewMaxY, kScreenWidth, 50)];
    toolBar = [[NSBundle mainBundle] loadNibNamed:@"XDInfoNewsToolBar" owner:nil options:nil].lastObject;
    toolBar.frame = backview.bounds;
    toolBar.commentLabel.text = self.infoModel.browseNum;
    toolBar.zanLabel.text = self.infoModel.praiseNum;
    if (self.infoModel.isThumbup.integerValue == 0) {
        toolBar.zanBtn.selected = NO;
    } else if (self.infoModel.isThumbup.integerValue == 1) {
        toolBar.zanBtn.selected = YES;
    }
    if (self.infoModel.attachments.count == 0) {
        toolBar.listBtn.hidden = YES;
    }
    toolBar.delegate = self;
    [backview addSubview:toolBar];
    [self.view addSubview:backview];
}

#pragma mark -- toolBarDelegate
// 点赞或取消点赞
- (void)clickZanBtn:(UIButton *)button {
    WEAKSELF
    if (!button.isSelected) {
        // 点赞
        [XDHTTPRequst praiseContnetWithID:self.infoModel.contentID succeed:^(id res) {
            if ([res[@"code"] integerValue] != 200) {
                [weakSelf recoverZanButton:button isPraise:YES];
                [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
            }
        } fail:^(NSError *error) {
            [weakSelf recoverZanButton:button isPraise:YES];
            [XDHTTPRequst showErrorMessageWith:error];
        }];
    } else {
        // 取消点赞
        [XDHTTPRequst cancelPraiseContnetWithID:self.infoModel.contentID succeed:^(id res) {
            if ([res[@"code"] integerValue] != 200) {
                [weakSelf recoverZanButton:button isPraise:NO];
                [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
            }
        } fail:^(NSError *error) {
            [weakSelf recoverZanButton:button isPraise:NO];
            [XDHTTPRequst showErrorMessageWith:error];
        }];
    }
    button.selected = !button.selected;
}

// 点赞失败后恢复按钮状态
- (void)recoverZanButton:(UIButton *)button isPraise:(BOOL)isPraise {
    NSInteger zanNum = toolBar.zanLabel.text.integerValue;
    if (isPraise) {
        zanNum -= 1;
    } else {
        zanNum += 1;
    }
    toolBar.zanLabel.text = [NSString stringWithFormat:@"%ld", (long)zanNum];
    button.selected = !button.selected;
}

// 分享
- (void)clickShareBtn:(UIButton *)button {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_QQ),
                                               /*@(UMSocialPlatformType_Sina)*/]];
    // 显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        // 创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        // 创建图片内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"通知公告" descr:self.infoModel.title thumImage:self.infoModel.coverUrl];
        shareObject.webpageUrl = self.infoModel.detailUrl;
        messageObject.shareObject = shareObject;
        // 调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            } else {
                NSLog(@"response data is %@",data);
            }
        }];
    }];
}

// 附件列表
- (void)clickListBtn:(UIButton *)button {
    XDAttachmentsListController *list = [[XDAttachmentsListController alloc] init];
    list.resourceArray = self.infoModel.attachments;
    [self.navigationController pushViewController:list animated:YES];
}

@end
