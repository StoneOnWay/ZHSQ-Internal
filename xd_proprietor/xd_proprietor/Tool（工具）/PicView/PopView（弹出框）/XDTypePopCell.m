//
//  XDTypePopCell.m
//  DMDropDownMenu
//
//  Created by zc on 2017/6/19.
//  Copyright © 2017年 Draven_M. All rights reserved.
//

#import "XDTypePopCell.h"

@implementation XDTypePopCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"XDTypePopCell";
    XDTypePopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XDTypePopCell" owner:nil options:nil] lastObject];
    }
    return cell;
    
}

@end
