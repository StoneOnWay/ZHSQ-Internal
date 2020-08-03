//
//  XDCarCharterCell.m
//  xd_proprietor
//
//  Created by cfsc on 2019/6/17.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDCarCharterCell.h"
#import "XDVehicleModel.h"

@implementation XDCarCharterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)charterAction:(id)sender {
    if (self.charterBtnClick) {
        self.charterBtnClick();
    }
}

- (void)setVehicleModel:(XDVehicleModel *)vehicleModel {
    _vehicleModel = vehicleModel;
    self.charterNameLabel.text = vehicleModel.typeName;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.charterBtn setTitle:@"包期" forState:UIControlStateNormal];
    if (vehicleModel.type.integerValue == 2) {
        // 七天内到期处理：改为续费
        NSString *nowTimeStr = [XDUtil getNowTimeStrWithFormatter:CarCharterDateFormatter];
        NSInteger dayCount = [XDUtil getDistanceWithFirstDate:nowTimeStr secondDate:vehicleModel.endTime dateFormatter:CarCharterDateFormatter];
        if (dayCount > 31) {
            self.charterBtn.hidden = YES;
        } else {
            self.charterBtn.hidden = NO;
            [self.charterBtn setTitle:@"续费" forState:UIControlStateNormal];
        }
        self.charterTimeLabel.text = [NSString stringWithFormat:@"%@至%@", vehicleModel.startTime, vehicleModel.endTime];
        self.charterTimeLabelHeightConstraint.constant = 17;
        [self layoutIfNeeded];
    } else {
        self.charterTimeLabelHeightConstraint.constant = 0;
        [self layoutIfNeeded];
        if (vehicleModel.type.integerValue == 1) {
            self.charterBtn.hidden = NO;
        } else {
            self.charterBtn.hidden = YES;
        }
    }
}

@end
