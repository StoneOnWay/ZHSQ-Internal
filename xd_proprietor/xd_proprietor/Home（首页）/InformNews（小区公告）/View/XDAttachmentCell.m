//
//  XDAttachmentCell.m
//  XD业主
//
//  Created by zc on 2018/5/8.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDAttachmentCell.h"

@implementation XDAttachmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDAttachmentCell";
    XDAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDAttachmentCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
    
}

@end
