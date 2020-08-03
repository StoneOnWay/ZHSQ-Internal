//
//  XDCarListCell.m
//  xd_proprietor
//
//  Created by stone on 22/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDCarListCell.h"
#import "XDVehicleModel.h"

@implementation XDCarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setVehicleModel:(XDVehicleModel *)vehicleModel {
    _vehicleModel = vehicleModel;
    if (vehicleModel.vehicleImageResource) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:vehicleModel.vehicleImageResource.url] placeholderImage:[UIImage imageNamed:@"load_fail"]];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"car_default"];
    }
    self.plateNoLabel.text = vehicleModel.plateNO;
    self.plateTypeLabel.text = vehicleModel.plateTypeText;
    self.plateColorLabel.text = vehicleModel.plateColorText;
    self.carTypeLabel.text = vehicleModel.vehicleTypeText;
    self.carColorLabel.text = vehicleModel.vehicleColorText;
    if (vehicleModel.auditStatus.integerValue == 0) {
        self.checkingImageView.hidden = NO;
        self.charterLabel.hidden = YES;
    } else {
        self.checkingImageView.hidden = YES;
        self.charterLabel.hidden = NO;
        if (vehicleModel.typeName) {
            UIColor *allowColor = [UIColor colorWithHexString:@"13AD57"];
            CGSize size = [vehicleModel.typeName sizeWithAttributes:@{NSFontAttributeName:self.charterLabel.font}];
            self.charterLabelWidthContraints.constant = size.width + 10;
            self.charterLabel.text = vehicleModel.typeName;
            [self drawTypeLabel:self.charterLabel color:allowColor];
        }
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
