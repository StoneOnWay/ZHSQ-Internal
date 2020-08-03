//
//  XDAttachmentCell.h
//  XD业主
//
//  Created by zc on 2018/5/8.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDAttachmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabels;
@property (weak, nonatomic) IBOutlet UIView *lineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
