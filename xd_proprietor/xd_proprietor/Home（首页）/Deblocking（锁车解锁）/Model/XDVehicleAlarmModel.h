//
//  XDVehicleAlarmModel.h
//  xd_proprietor
//
//  Created by stone on 16/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDVehicleAlarmModel : NSObject

// 布控唯一标识
@property (nonatomic, copy) NSString *alarmSyscode;
// 车牌号码
@property (nonatomic, copy) NSString *plateNo;
// 卡号
@property (nonatomic, copy) NSString *cardNo;
// 驾驶员名称
@property (nonatomic, copy) NSString *driver;
// 驾驶员电话
@property (nonatomic, copy) NSString *driverPhone;
// 备注信息
@property (nonatomic, copy) NSString *remark;
// 布控结束时间
@property (nonatomic, copy) NSString *endTime;

@end

NS_ASSUME_NONNULL_END
