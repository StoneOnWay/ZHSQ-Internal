//
//  XDDelockingCarCell.m
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDDelockingCarCell.h"

@implementation XDDelockingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.switchBtn setImage:[UIImage imageNamed:@"btn_guan"] forState:UIControlStateNormal];
    [self.switchBtn setImage:[UIImage imageNamed:@"btn_kai"] forState:UIControlStateSelected];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDDelockingCarCell";
    XDDelockingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDDelockingCarCell" owner:nil options:nil]lastObject];
    }
//    cell.backgroundColor = backColor;
    return cell;
    
}

- (IBAction)switchImageBtnClicked:(UIButton *)sender {
    
    if (self.switchBtnBlock) {
        self.switchBtnBlock(sender);
    }
}


@end
