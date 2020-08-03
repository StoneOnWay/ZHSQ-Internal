//
//  XDTypePopCell.h
//  DMDropDownMenu
//
//  Created by zc on 2017/6/19.
//  Copyright © 2017年 Draven_M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDTypePopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabels;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
