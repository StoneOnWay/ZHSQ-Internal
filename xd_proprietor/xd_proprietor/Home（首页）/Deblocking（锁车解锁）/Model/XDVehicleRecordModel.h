//
//  XDVehicleRecordModel.h
//  xd_proprietor
//
//  Created by stone on 16/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VehicleReleaseMode) {
    VehicleReleaseModeForbidden = 0, // 禁止放行
    VehicleReleaseModeContract = 1, // 固定车包期
    VehicleReleaseModeTemporary = 2, // 临时车入场
    VehicleReleaseModeOutlineOut = 10, // 离线出场
    VehicleReleaseModePayOut = 11, // 缴费出场
    VehicleReleaseModePrepayment = 12, // 预付费出场
    VehicleReleaseModeFreeOut = 13, // 免费出场
    VehicleReleaseModeIllegality = 30, // 非法不放行
    VehicleReleaseModeGroupOut = 35 // 群组出行
};

NS_ASSUME_NONNULL_BEGIN

@interface XDVehicleRecordModel : NSObject

// 车牌号码
@property (nonatomic, copy) NSString *plateNo;
// 创建时间
@property (nonatomic, copy) NSString *createTime;
// 通过时间
@property (nonatomic, copy) NSString *crossTime;
// 是否出场 0 进场 1 出场
@property (nonatomic, strong) NSNumber *vehicleOut;

// 进场时间
@property (nonatomic, copy) NSString *inTime;
// 出场时间
@property (nonatomic, copy) NSString *outTime;
// 放行模式
@property (nonatomic, strong) NSNumber *releaseMode;

@end

NS_ASSUME_NONNULL_END
