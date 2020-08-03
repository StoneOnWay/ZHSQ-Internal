//
//  XDVisitListCell.h
//  XD业主
//
//  Created by zc on 2017/8/9.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDVisitListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabels;
@property (weak, nonatomic) IBOutlet UILabel *timeLabels;
@property (weak, nonatomic) IBOutlet UILabel *isOutUse;
@property (weak, nonatomic) IBOutlet UIView *lineView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
