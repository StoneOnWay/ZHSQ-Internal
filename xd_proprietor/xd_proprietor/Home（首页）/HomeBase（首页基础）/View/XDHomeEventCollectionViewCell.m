//
//  XDHomeEventCollectionViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/8/31.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDHomeEventCollectionViewCell.h"

@interface XDHomeEventCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation XDHomeEventCollectionViewCell

- (void)setHomeMenuModel:(XDHomeMenuModel *)homeMenuModel {
    _homeMenuModel = homeMenuModel;
    self.iconImageView.image = [UIImage imageNamed:homeMenuModel.icon];
    self.titleLabel.text = homeMenuModel.title;
}

@end
