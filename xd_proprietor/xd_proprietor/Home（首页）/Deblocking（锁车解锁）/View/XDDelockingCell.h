//
//  XDDelockingCell.h
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDVehicleRecordModel;
@interface XDDelockingCell : UITableViewCell
//车牌
@property (weak, nonatomic) IBOutlet UILabel *carNumber;
//入场时间
@property (weak, nonatomic) IBOutlet UILabel *comeTime;
//出场时间
@property (weak, nonatomic) IBOutlet UILabel *outTime;
//停车时间
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
// 放行类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (nonatomic, strong) XDVehicleRecordModel *recordModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
