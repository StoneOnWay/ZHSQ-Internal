//
//  XDNotOpenController.m
//  XD业主
//
//  Created by zc on 2017/7/2.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDNotOpenController.h"


@interface XDNotOpenController ()

@end

@implementation XDNotOpenController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setOnOpenNavi];
}

/**
 *  设置导航栏
 */
- (void)setOnOpenNavi{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"暂未开放";
    self.navigationItem.titleView = titleLabel;
}


@end
