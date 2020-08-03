//
//  Created by cfsc on 2020/2/5.
//  Copyright © 2020年 cfsc. All rights reserved.
//

#import "XDOpenClokController.h"

@interface XDOpenClokController ()<CustomAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@end

@implementation XDOpenClokController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开锁";
    [self getCodeImage];
}

- (void)getCodeImage {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *cardNo = loginInfo.userModel.defaultCardNo;
    NSString *phaseId = loginInfo.userModel.currentDistrict.phaseId;
    NSString *effectTime = [XDUtil getNowTimeStrWithFormatter:@"yyMMddHHmmss"];
    NSString *expireTime = [XDUtil getDateStrWithFormatter:@"yyMMddHHmmss" sinceNow:5*60];
    if (!cardNo || !phaseId) {
        [MBProgressHUD showTipMessageInView:@"登录用户信息有误！"];
        return;
    }
    NSDictionary *dic = @{
                          @"cardNo":cardNo,
                          @"effectTime":effectTime,
                          @"expireTime":expireTime,
                          @"openTimes":@4,
                          @"phaseId":phaseId
                          };
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst getLockQrcodeWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            NSString *codeUrl = res[@"result"][@"qrCodeUrl"];
            [self.codeImage sd_setImageWithURL:[NSURL URLWithString:codeUrl] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [MBProgressHUD hideHUD];
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

- (IBAction)codeBtnClick:(UIButton *)sender {
    [self getCodeImage];
}

@end
