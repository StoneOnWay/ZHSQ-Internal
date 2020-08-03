//
//  XDDelockingCell.m
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDDelockingCell.h"
#import "XDVehicleRecordModel.h"

@implementation XDDelockingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"XDDelockingCell";
    XDDelockingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDDelockingCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
}

- (void)setRecordModel:(XDVehicleRecordModel *)recordModel {
    _recordModel = recordModel;
    self.carNumber.text = recordModel.plateNo;
    self.comeTime.text = recordModel.inTime;
    self.outTime.text = recordModel.outTime;
    self.totalTime.text = @"";
    
    UIColor *forbidColor = [UIColor colorWithHexString:@"fe552e"];
    UIColor *allowColor = [UIColor colorWithHexString:@"13AD57"];
    switch (recordModel.releaseMode.intValue) {
        case VehicleReleaseModeForbidden:
            self.typeLabel.text = @" 禁止放行 ";
            [self drawTypeLabel:self.typeLabel color:forbidColor];
            break;
        case VehicleReleaseModeContract:
            self.typeLabel.text = @" 固定车包期 ";
            [self drawTypeLabel:self.typeLabel color:allowColor];
            break;
        case VehicleReleaseModeTemporary:
            self.typeLabel.text = @" 临时车入场 ";
            [self drawTypeLabel:self.typeLabel color:allowColor];
            break;
        case VehicleReleaseModeOutlineOut:
            self.typeLabel.text = @" 离线出场 ";
            [self drawTypeLabel:self.typeLabel color:allowColor];
            break;
        case VehicleReleaseModePayOut:
            self.typeLabel.text = @" 缴费出场 ";
            [self drawTypeLabel:self.typeLabel color:allowColor];
            break;
        case VehicleReleaseModePrepayment:
            self.typeLabel.text = @" 预付费出场 ";
            [self drawTypeLabel:self.typeLabel color:allowColor];
            break;
        case VehicleReleaseModeFreeOut:
            self.typeLabel.text = @" 免费出场 ";
            [self drawTypeLabel:self.typeLabel color:allowColor];
            break;
        case VehicleReleaseModeIllegality:
            self.typeLabel.text = @" 非法卡不放行 ";
            [self drawTypeLabel:self.typeLabel color:forbidColor];
            break;
        default:
            self.typeLabel.text = @" 缴费出场 ";
            [self drawTypeLabel:self.typeLabel color:allowColor];
            break;
    }
}

- (void)drawTypeLabel:(UILabel *)label color:(UIColor *)color {
    label.layer.borderColor = color.CGColor;
    label.layer.cornerRadius = 2.0f;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1.0f;
    label.textColor = color;
}

@end
