//
//  Created by cfsc on 2020/3/4.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDRegistViewController.h"
#import "XDProjectSelectController.h"

@interface XDRegistViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
// 记录倒计时
@property (nonatomic, assign) NSInteger countDownTime;
@property (nonatomic, strong) NSTimer *timer;
// 验证码key
@property (nonatomic, copy) NSString *validKey;

@end

@implementation XDRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    self.countDownTime = 60;
    self.validKey = @"";
    self.registButton.layer.cornerRadius = 5.f;
    self.registButton.layer.masksToBounds = YES;
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    [self.phoneTextField becomeFirstResponder];
}

- (void)tipsWithToLogin {
    UIViewController *rootVC = [[AppDelegate shareAppDelegate] topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    NSString *string = [NSString stringWithFormat:@"该手机号已经被注册，是否前往登录？"];
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertvc addAction:sureAction];
    [alertvc addAction:cancelAction];
    [rootVC presentViewController:alertvc animated:YES completion:nil];
}

- (IBAction)getCodeAction:(id)sender {
    if (![XDUtil valiMobile:self.phoneTextField.text]) {
        [MBProgressHUD showTipMessageInView:@"请输入正确的手机号"];
        return;
    }
    WEAKSELF
    // 检查手机号是否被注册
    [XDHTTPRequst uniqueCheckWithTableName:@"`smart-basic`.cfc_household_info" fieldName:@"mobile" fieldValue:self.phoneTextField.text dataId:nil succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.codeTextField becomeFirstResponder];
            weakSelf.getCodeButton.enabled = NO;
            [XDHTTPRequst sendSmsCodeWithPhone:self.phoneTextField.text succeed:^(id res) {
                [MBProgressHUD hideHUD];
                if ([res[@"code"] integerValue] == 200) {
                    [weakSelf countDown];
                    weakSelf.validKey = res[@"result"][@"key"];
                } else {
                    weakSelf.getCodeButton.enabled = YES;
                    [MBProgressHUD showTipMessageInView:res[@"message"]];
                }
            } fail:^(NSError *error) {
                weakSelf.getCodeButton.enabled = YES;
                [MBProgressHUD hideHUD];
                [XDHTTPRequst showErrorMessageWith:error];
            }];
        } else if ([res[@"code"] integerValue] == 409) {
            [MBProgressHUD hideHUD];
            // 提示已经存在账号，是否前往登录
            [weakSelf tipsWithToLogin];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"]];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (IBAction)registAction:(id)sender {
    if (!self.codeTextField.text || [self.codeTextField.text isEqualToString:@""]) {
        [MBProgressHUD showTipMessageInView:@"请输入正确的验证码！"];
        return;
    }
    WEAKSELF
    NSString *phoneNo = weakSelf.phoneTextField.text;
    NSString *key = weakSelf.validKey;
    NSString *validNo = weakSelf.codeTextField.text;
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst registHouseHolderWithPhoneNo:phoneNo validKey:key validNo:validNo loginMode:@"MOBILE" succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf loginWithMobile:phoneNo key:key validNo:validNo];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 登录
- (void)loginWithMobile:(NSString *)phoneNo key:(NSString *)key validNo:(NSString *)validNo {
    // 登录
    [XDHTTPRequst loginHouseHolderWithMobile:phoneNo key:key validNo:validNo succeed:^(NSDictionary *res) {
        if ([res[@"code"] integerValue] == 200) {
            __block XDLoginInfoModel *loginInfo = [[XDLoginInfoModel alloc] init];
            // 存储token
            XDLoginTokenModel *model = [XDLoginTokenModel mj_objectWithKeyValues:res[@"result"]];
            loginInfo.tokenModel = model;
            [XDArchiverManager saveLoginInfo:loginInfo];
            // 根据手机号获取用户
            [XDHTTPRequst getUserInfoCacheSucceed:^(id res) {
                if ([res[@"code"] integerValue] == 200) {
                    XDUserModel *userModel = [XDUserModel mj_objectWithKeyValues:res[@"result"]];
                    loginInfo.userModel = userModel;
                    [XDArchiverManager saveLoginInfo:loginInfo];
                    [MBProgressHUD hideHUD];
                    if (!userModel.currentDistrict.projectId) {
                        // 跳转至项目选择
                        XDProjectSelectController *projectSelectVC = [[XDProjectSelectController alloc] init];
                        projectSelectVC.canGoBack = NO;
                        [self.navigationController pushViewController:projectSelectVC animated:YES];
                    } else {
                        [[XDCommonBusiness shareInstance] setPushTagsAndAlias];
                        // 进入首页
                        UIWindow *window = [[UIApplication sharedApplication].delegate window];
                        [AppDelegate shareAppDelegate].tabBarViewController = [[BaseTabBarViewController alloc]init];
                        window.rootViewController = [AppDelegate shareAppDelegate].tabBarViewController;
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

- (void)countDown {
    __weak typeof(self) weakSelf = self;
    [weakSelf.getCodeButton setTitle:@"60 (s)" forState:UIControlStateNormal];
    weakSelf.timer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(countDownNumbers) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSDefaultRunLoopMode];
}

- (void)countDownNumbers {
    self.countDownTime -= 1;
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"%ld (s)",(long)self.countDownTime] forState:UIControlStateNormal];
    if (self.countDownTime == 0) {
        [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getCodeButton.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.countDownTime = 60;
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    self.countDownTime = 60;
}

#pragma mark - 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    return YES;
}

@end
