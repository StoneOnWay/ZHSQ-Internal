//
//  XDBillModel.h
//  xd_proprietor
//
//  Created by stone on 18/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDBillModel : NSObject

// 入场时间
@property (nonatomic, copy) NSString *enterTime;
// 停车时长
@property (nonatomic, strong) NSNumber *parkTime;
// 应收金额
@property (nonatomic, copy) NSString *supposeCost;
// 实付金额
@property (nonatomic, copy) NSString *paidCost;
// 账单唯一标识
@property (nonatomic, copy) NSString *billSyscode;

@end

NS_ASSUME_NONNULL_END
