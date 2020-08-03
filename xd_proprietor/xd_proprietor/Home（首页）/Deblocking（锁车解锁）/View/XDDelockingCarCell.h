//
//  XDDelockingCarCell.h
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDDelockingCarCell : UITableViewCell

//开关
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
//是否解锁的label
@property (weak, nonatomic) IBOutlet UILabel *isLock;
//是否解锁的image
@property (weak, nonatomic) IBOutlet UIImageView *lockImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic ,strong) void(^switchBtnBlock)(UIButton *button);

@end
