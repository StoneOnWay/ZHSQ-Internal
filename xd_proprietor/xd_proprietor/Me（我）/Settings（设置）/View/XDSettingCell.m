//
//  XDSettingCell.m
//  xd_proprietor
//
//  Created by stone on 15/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDSettingCell.h"
#import "XDSettingsConfigModel.h"

@implementation XDSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setConfigModel:(XDSettingsConfigModel *)configModel {
    _configModel = configModel;
    self.titleLable.text = configModel.title;
    self.subTitleLable.text = configModel.subTitle;
    if (configModel.hasArrow) {
        self.arrowImageView.hidden = NO;
    } else {
        self.arrowImageView.hidden = YES;
    }
}

@end
