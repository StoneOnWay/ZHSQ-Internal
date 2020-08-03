//
//  Created by cfsc on 2020/6/18.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDRemoteOpenTableCell.h"

@implementation XDRemoteOpenTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deviceStatusLabel.layer.cornerRadius = 10.f;
    self.deviceStatusLabel.layer.masksToBounds = YES;
    self.deviceStatusLabel.layer.borderWidth = 1.f;
    self.deviceStatusLabel.layer.borderColor = BianKuang.CGColor;
    self.openBtn.layer.cornerRadius = 15.f;
    self.openBtn.layer.masksToBounds = YES;
    self.openBtn.layer.borderWidth = 1.f;
    self.openBtn.layer.borderColor = BianKuang.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setEquipment:(XDEquipmentModel *)equipment {
    _equipment = equipment;
    self.deviceNameLabel.text = equipment.deviceName;
    self.deviceStatusLabel.text = equipment.deviceStatus.integerValue == 1 ? @"在线" : @"离线";
    self.deviceStatusLabel.textColor = equipment.deviceStatus.integerValue == 1 ? OnlineColor : [UIColor lightGrayColor];
}

- (IBAction)openAction:(id)sender {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (!self.equipment.deviceSerial || !loginInfo.userModel.currentDistrict.phaseId) {
        return;
    }
    NSDictionary *dic = @{
        @"deviceSerial":self.equipment.deviceSerial,
        @"phaseId":loginInfo.userModel.currentDistrict.phaseId,
        @"cmd":@"open"
    };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = @"";
    hud.label.font=[UIFont systemFontOfSize:14];
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    [XDHTTPRequst hikRemoteOpenWithDic:dic succeed:^(id res) {
        [hud hideAnimated:YES];
        if ([res[@"code"] integerValue] == 200) {
            [XDUtil showToast:@"门已打开"];
        } else {
            [XDUtil showToast:res[@"message"]];
        }
    } fail:^(NSError *error) {
        [hud hideAnimated:YES];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

@end
