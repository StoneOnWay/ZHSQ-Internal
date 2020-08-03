//
//  XDPersonInfoCell.m
//  xd_proprietor
//
//  Created by stone on 14/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDPersonInfoCell.h"
#import "XDPersonalConfigModel.h"

@implementation XDPersonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPersonInfo:(XDPersonalConfigModel *)personInfo {
    _personInfo = personInfo;
    self.titleLabel.text = personInfo.title;
    self.subTitleLabel.text = personInfo.subTitle;
    if (personInfo.hasArrow) {
        self.arrowImageView.hidden = NO;
        self.subTitleTrailingConstraint.constant = 8;
    } else {
        self.arrowImageView.hidden = YES;
        self.subTitleTrailingConstraint.constant = 0;
    }
    if (personInfo.isImage) {
        self.headImageView.hidden = NO;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:personInfo.headUrl] placeholderImage:[UIImage imageNamed:@"wode_touxiang"]];
    } else {
        self.headImageView.hidden = YES;
    }
}

@end
