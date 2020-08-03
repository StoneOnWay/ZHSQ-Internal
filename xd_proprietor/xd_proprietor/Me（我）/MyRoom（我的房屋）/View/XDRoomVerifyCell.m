//
//  Created by cfsc on 2020/3/12.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDRoomVerifyCell.h"
#import "XDRoomModel.h"

@implementation XDRoomVerifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.roomStateView.layer.cornerRadius = 5.f;
    self.roomStateView.layer.masksToBounds = YES;
    self.refuseBtn.layer.cornerRadius = 5.f;
    self.refuseBtn.layer.masksToBounds = YES;
    self.acceptBtn.layer.cornerRadius = 5.f;
    self.acceptBtn.layer.masksToBounds = YES;
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setVerifyModel:(XDVerifyModel *)verifyModel {
    _verifyModel = verifyModel;
    self.mobileLabel.text = verifyModel.mobile;
    self.refuseBtn.hidden = YES;
    self.acceptBtn.hidden = YES;
    NSString *type = @"业主";
    if ([verifyModel.type isEqualToString:@"JS"]) {
        type = @"家属";
    } else if ([verifyModel.type isEqualToString:@"ZH"]) {
        type = @"租户";
    }
    self.typeLabel.text = type;
    if ([verifyModel.remark isEqualToString:@""] || !verifyModel.remark) {
        self.remarkLabel.text = @"无备注信息";
    } else {
        self.remarkLabel.text = verifyModel.remark;
    }
    self.timeLabel.text = verifyModel.createTime;
    if (verifyModel.status.integerValue == 1) {
        self.stateLabel.text = @"等待审核";
        self.roomStateView.backgroundColor = [UIColor lightGrayColor];
        self.refuseBtn.hidden = NO;
        self.acceptBtn.hidden = NO;
    } else if (verifyModel.status.integerValue == 2) {
        self.stateLabel.text = @"审核通过";
        self.roomStateView.backgroundColor = RGB(19, 173, 87);
    } else if (verifyModel.status.integerValue == 3) {
        self.stateLabel.text = @"审核被拒";
        self.roomStateView.backgroundColor = [UIColor lightGrayColor];
    }  else if (verifyModel.status.integerValue == 4) {
        self.stateLabel.text = @"审核失效";
        self.roomStateView.backgroundColor = [UIColor lightGrayColor];
    }
}

- (IBAction)refuseAction:(id)sender {
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst refuseRoomVerifyWithVerifyId:self.verifyModel.verifyId succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            if (self.verifyCompleted) {
                self.verifyCompleted();
            }
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (IBAction)acceptAction:(id)sender {
    NSString *houseHolderId = self.verifyModel.householdId ? self.verifyModel.householdId : @"";
    NSString *roomId = self.verifyModel.roomId ? self.verifyModel.roomId : @"";
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
                          @"householdId":houseHolderId,
                          @"id":self.verifyModel.verifyId,
                          @"roomId":roomId,
                          @"type":self.verifyModel.type
                          };
    [XDHTTPRequst passRoomVerifyWithDic:dic succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            if (self.verifyCompleted) {
                self.verifyCompleted();
            }
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

@end
