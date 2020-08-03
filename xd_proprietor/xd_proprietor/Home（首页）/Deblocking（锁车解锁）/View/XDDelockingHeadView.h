//
//  XDDelockingHeadView.h
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDDelockingHeadView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIView *backViews;

//车牌号码
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView withType:(NSString *)type;

@property (weak, nonatomic) IBOutlet UIButton *popBtn;

@end
