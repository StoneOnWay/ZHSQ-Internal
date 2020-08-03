//
//  Created by cfsc on 2020/5/14.
//  Copyright © 2020 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDResourceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDVehicleModel : NSObject
// 车辆id
@property (nonatomic, copy) NSString *vehicleId;
// 车牌号码
@property (nonatomic, copy) NSString *plateNO;
// 车辆颜色
@property (nonatomic, copy) NSString *vehicleColorText;
// 车辆类型
@property (nonatomic, copy) NSString *vehicleTypeText;
// 车牌颜色
@property (nonatomic, copy) NSString *plateColorText;
// 车牌类型
@property (nonatomic, copy) NSString *plateTypeText;
// 车辆照片
@property (nonatomic, strong) XDResourceModel *vehicleImageResource;
// 缴费方式( 1 临时车 2 包期车 3 群组车)
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeName;
// 是否过期
@property (nonatomic, copy) NSString *overDue;
// 审核状态 0-未审核 1-审核通过
@property (nonatomic, copy) NSString *auditStatus;
// 包租有效期
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

/**非数据库字段*/
// 车辆布控状态 1-解锁状态 0-被锁状态
@property (nonatomic, strong) NSNumber *state;
// 车辆布控唯一标识
@property (nonatomic, copy, nullable) NSString *alarmSyscode;

@end

NS_ASSUME_NONNULL_END
