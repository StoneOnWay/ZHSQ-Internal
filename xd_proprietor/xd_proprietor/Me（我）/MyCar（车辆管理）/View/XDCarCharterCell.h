//
//  XDCarCharterCell.h
//  xd_proprietor
//
//  Created by cfsc on 2019/6/17.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CarCharterDateFormatter @"yyyy-MM-dd"

@class XDVehicleModel;
NS_ASSUME_NONNULL_BEGIN

@interface XDCarCharterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *charterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *charterTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charterTimeLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *charterBtn;
@property (copy, nonatomic) void (^charterBtnClick)(void);
@property (strong, nonatomic) XDVehicleModel *vehicleModel;

@end

NS_ASSUME_NONNULL_END
