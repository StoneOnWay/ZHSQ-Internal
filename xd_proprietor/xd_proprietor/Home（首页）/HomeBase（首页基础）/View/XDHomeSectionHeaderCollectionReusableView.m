//
//  XDHomeSectionHeaderCollectionReusableView.m
//  xd_proprietor
//
//  Created by mason on 2018/9/3.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDHomeSectionHeaderCollectionReusableView.h"

@interface XDHomeSectionHeaderCollectionReusableView()

@end

@implementation XDHomeSectionHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorHex(f3f3f3);
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15.f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    titleLabel.text = @"我的服务";
    titleLabel.textColor = UIColorHex(4f4f4f);
    titleLabel.font = [UIFont systemFontOfSize:12.f];
    self.titleLabel = titleLabel;
}

@end
