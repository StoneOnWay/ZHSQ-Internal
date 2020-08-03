//
//  XDPayMethodCell.m
//  xd_proprietor
//
//  Created by stone on 28/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDPayMethodCell.h"
#import "XDPayMethod.h"

@implementation XDPayMethodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentWithPayModel:(XDPayMethod *)method {
    self.iconImageView.image = [UIImage imageNamed:method.iconName];
    self.titleLabel.text = method.title;
    self.detailLabel.text = method.detailTitle;
    self.tipsImageView.hidden = !method.isRecommend;
}

@end
