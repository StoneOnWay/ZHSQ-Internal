//
//  Created by cfsc on 2020/3/14.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDRoomIdentifyVerifyController.h"
#import "BRPlaceholderTextView.h"
#import "XDPageContainerController.h"

@interface XDRoomIdentifyVerifyController ()
@property (weak, nonatomic) IBOutlet UITextField *idCardNOTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

@end

@implementation XDRoomIdentifyVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交个人信息";
    [self configUI];
}

- (void)configUI {
    self.verifyButton.layer.cornerRadius = 5.f;
    self.summaryTextView.placeholder = @"其它说明";
    [self.summaryTextView setPlaceholderColor:[UIColor lightGrayColor]];
    [self.summaryTextView setPlaceholderFont:[UIFont systemFontOfSize:14]];
    self.summaryTextView.layer.cornerRadius = 5.f;
    self.summaryTextView.layer.borderWidth = 0.5;
    self.summaryTextView.layer.borderColor = RGB(211, 211, 211).CGColor;
    self.summaryTextView.layer.masksToBounds = YES;
}

- (IBAction)verifyAction:(id)sender {
    [self.view endEditing:YES];
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (!loginInfo.userModel.userID || !self.roomModel.roomId || !self.roomIdentifyType) {
        return;
    }
    NSString *idCardNoStr = self.idCardNOTextField.text ? self.idCardNOTextField.text : @"";
    NSString *phoneNoStr = self.phoneNoTextField.text ? self.phoneNoTextField.text : @"";
    NSString *remarkStr = self.summaryTextView.text ? self.summaryTextView.text : @"";
    NSDictionary *dic = @{
                          @"idcardNo":idCardNoStr,
                          @"mobile":phoneNoStr,
                          @"householdId":loginInfo.userModel.userID,
                          @"roomId":self.roomModel.roomId,
                          @"type":self.roomIdentifyType,
                          @"remark":remarkStr
                          };
    [MBProgressHUD showActivityMessageInView:nil];
    WEAKSELF
    // 提交审核
    [XDHTTPRequst confirmRoomVerifyWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"XDPageContainerController" bundle:nil];
            XDPageContainerController *pageVC = [storyboard instantiateViewControllerWithIdentifier:@"XDPageContainerController"];
            pageVC.toVC = @"XDOtherRoomController";
            [weakSelf.navigationController pushViewController:pageVC animated:YES];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
