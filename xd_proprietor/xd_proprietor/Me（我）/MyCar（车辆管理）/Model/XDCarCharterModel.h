//
//  XDCarCharterModel.h
//  xd_proprietor
//
//  Created by cfsc on 2019/6/18.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/** 车辆包期模型 **/
@interface XDCarCharterModel : NSObject
// 停车库唯一标识
@property (nonatomic, copy) NSString *parkSyscode;
// 车牌号码
@property (nonatomic, copy) NSString *plateNo;
// 包期费用
@property (nonatomic, copy) NSString *fee;
// 包期开始时间
@property (nonatomic, copy) NSString *startTime;
// 包期结束时间
@property (nonatomic, copy) NSString *endTime;
@end

NS_ASSUME_NONNULL_END
