//
//  XDLoginViewController.m
//  登录
//
//  Created by zc on 17/3/30.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDLoginViewController.h"
#import "XDRegistViewController.h"
#import "XDProjectSelectController.h"

@interface XDLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TelephoneTF;
@property (weak, nonatomic) IBOutlet UITextField *CodeTF;
@property (nonatomic, strong) NSString *smscode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopConstraint;
// 发送短信按钮
@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
// 记录倒计时
@property (nonatomic, assign) NSInteger countDownTime;
@property (nonatomic, strong) NSTimer *time;
// 验证码key
@property (nonatomic, copy) NSString *validKey;
@end

@implementation XDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countDownTime = 60;
    self.validKey = @"";
    self.TelephoneTF.delegate = self;
    self.CodeTF.delegate = self;
    if (kScreenWidth == 320) {
        self.iconTopConstraint.constant = 50;
    }
}

// 注册
- (IBAction)registAction:(id)sender {
    XDRegistViewController *registVC = [[XDRegistViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}

#pragma mark - 获取验证码
- (IBAction)sendcode:(id)sender {
    if (![XDUtil valiMobile:self.TelephoneTF.text]) {
        [MBProgressHUD showTipMessageInView:@"请输入正确的手机号"];
        return;
    }
    [self.CodeTF becomeFirstResponder];
    self.smsCodeBtn.enabled = NO;
    WEAKSELF
    [XDHTTPRequst sendSmsCodeWithPhone:self.TelephoneTF.text succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf countDown];
            weakSelf.validKey = res[@"result"][@"key"];
        } else {
            weakSelf.smsCodeBtn.enabled = YES;
            [MBProgressHUD showTipMessageInView:res[@"message"]];
        }
    } fail:^(NSError *error) {
        weakSelf.smsCodeBtn.enabled = YES;
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)countDown {
    __weak typeof(self) weakSelf = self;
    [weakSelf.smsCodeBtn setTitle:@"60 (s)" forState:UIControlStateNormal];
    weakSelf.time = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(countDownNumbers) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:weakSelf.time forMode:NSDefaultRunLoopMode];
}

- (void)countDownNumbers {
    self.countDownTime -= 1;
    [self.smsCodeBtn setTitle:[NSString stringWithFormat:@"%ld (s)",(long)self.countDownTime] forState:UIControlStateNormal];
    if (self.countDownTime == 0) {
        [self.smsCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.smsCodeBtn.enabled = YES;
        [self.time invalidate];
        self.time = nil;
        self.countDownTime = 60;
    }
}

#pragma mark - 手机号验证码登录
- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    if (!self.CodeTF.text || [self.CodeTF.text isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInView:@"请输入正确的验证码！"];
        return;
    }
    WEAKSELF
    NSString *phoneNo = weakSelf.TelephoneTF.text;
    NSString *key = weakSelf.validKey;
    NSString *validNo = weakSelf.CodeTF.text;
    [MBProgressHUD showActivityMessageInView:nil];
    // 登录
    [XDHTTPRequst loginHouseHolderWithMobile:phoneNo key:key validNo:validNo succeed:^(NSDictionary *res) {
        if ([res[@"code"] integerValue] == 200) {
            __block XDLoginInfoModel *loginInfo = [[XDLoginInfoModel alloc] init];
            // 存储token
            XDLoginTokenModel *model = [XDLoginTokenModel mj_objectWithKeyValues:res[@"result"]];
            loginInfo.tokenModel = model;
            [XDArchiverManager saveLoginInfo:loginInfo];
            // 获取用户信息
            [XDHTTPRequst getUserInfoCacheSucceed:^(id res) {
                if ([res[@"code"] integerValue] == 200) {
                    XDUserModel *userModel = [XDUserModel mj_objectWithKeyValues:res[@"result"]];
                    loginInfo.userModel = userModel;
                    if (!loginInfo.userModel.currentDistrict.projectId) {
                        // 跳转至项目选择
                        XDProjectSelectController *projectSelectVC = [[XDProjectSelectController alloc] init];
                        projectSelectVC.canGoBack = NO;
                        [weakSelf goToVC:projectSelectVC withSaveLoginInfo:loginInfo];
                    } else {
                        [AppDelegate shareAppDelegate].tabBarViewController = [[BaseTabBarViewController alloc]init];
                        [weakSelf goToVC:[AppDelegate shareAppDelegate].tabBarViewController withSaveLoginInfo:loginInfo];
                    }
                } else {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
                }
            } fail:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [XDHTTPRequst showErrorMessageWith:error];
            }];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)goToVC:(UIViewController *)vc withSaveLoginInfo:(XDLoginInfoModel *)loginInfo {
    [XDArchiverManager saveLoginInfo:loginInfo];
    
    // 设置推送别名
    [[XDCommonBusiness shareInstance] setPushTagsAndAlias];
    
    [MBProgressHUD hideHUD];
    // 进入首页
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    window.rootViewController = vc;
}

- (IBAction)appServiceAction:(id)sender {
    JXBWebViewController *detailVC = [[JXBWebViewController alloc] initWithURLString:AppServiceProtocalUrl];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_TelephoneTF resignFirstResponder];
    [_CodeTF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_TelephoneTF resignFirstResponder];
    [_CodeTF resignFirstResponder];
    return YES;
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)dealloc {
    [self.time invalidate];
    self.time = nil;
    self.countDownTime = 60;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
