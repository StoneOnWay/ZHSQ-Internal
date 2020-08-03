//
//  XDDelockingHeadView.m
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDDelockingHeadView.h"

@implementation XDDelockingHeadView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView withType:(NSString *)type
{
    static NSString *ID=@"XDDelockingHeadView";
    XDDelockingHeadView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (head == nil) {
        if ([type isEqualToString:@"choiceCar"]) {
            
            //车辆选择
             head = [[[NSBundle mainBundle]loadNibNamed:@"XDDelockingChoiceCarHead" owner:nil options:nil]lastObject];
            
            
        }else{
            //出入记录
            head = [[[NSBundle mainBundle]loadNibNamed:@"XDDelockingHeadView" owner:nil options:nil]lastObject];
        }
    }
    
    return head;
}


@end
