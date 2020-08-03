//
//  XDInformNewsListCell.h
//  XD业主
//
//  Created by zc on 2017/6/24.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDInformNewsListCell : UITableViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabels;
//详细描述的label
@property (weak, nonatomic) IBOutlet UILabel *detailLabels;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (nonatomic , strong)NSString *iconImageUrl;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
