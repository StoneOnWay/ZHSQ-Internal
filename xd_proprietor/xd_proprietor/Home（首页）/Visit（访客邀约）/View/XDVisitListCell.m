//
//  XDVisitListCell.m
//  XD业主
//
//  Created by zc on 2017/8/9.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDVisitListCell.h"

@implementation XDVisitListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"XDVisitListCell";
    XDVisitListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDVisitListCell" owner:nil options:nil]lastObject];
    }
    return cell;
    
}

@end
