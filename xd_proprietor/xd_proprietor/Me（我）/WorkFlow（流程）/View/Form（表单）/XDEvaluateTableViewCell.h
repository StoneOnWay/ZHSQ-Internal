//
//  XDEvaluateTableViewCell.h
//  xd_proprietor
//
//  Created by mason on 2018/9/10.
//Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^textBlock)(NSString *text);

@interface XDEvaluateTableViewCell : UITableViewCell

@property (copy, nonatomic) textBlock textBlock;

@end
