//
//  XDNameEditController.m
//  xd_proprietor
//
//  Created by stone on 14/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDNameEditController.h"

@interface XDNameEditController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextFielf;

@end

@implementation XDNameEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑昵称";
    
    self.nameTextFielf.text = self.nickName;
    [self.nameTextFielf becomeFirstResponder];
    [self.nameTextFielf addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)changedTextField:(UITextField *)textField {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(confirmAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)confirmAction {
    [self.view endEditing:YES];
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    @weakify(self)
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
                          @"nickName":self.nameTextFielf.text,
                          @"id":loginInfo.userModel.userID
                          };
    [XDHTTPRequst updateUserSpecificFieldWithDic:dic succeed:^(id res) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            loginInfo.userModel.nickName = self.nameTextFielf.text;
            [XDArchiverManager saveLoginInfo:loginInfo];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

@end
