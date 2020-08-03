//
//  Created by cfsc on 2020/6/12.
//  Copyright © 2020 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDResourceModel;

NS_ASSUME_NONNULL_BEGIN

@interface XDActivityModel : NSObject

@property (nonatomic, copy) NSString *eventId;
// 标题
@property (nonatomic, copy) NSString *title;
// 地址
@property (nonatomic, copy) NSString *location;
// 报名截止日期
@property (nonatomic, copy) NSString *registrationDeadline;
// 活动开始时间
@property (nonatomic, copy) NSString *startTime;
// 活动结束时间
@property (nonatomic, copy) NSString *endTime;
// 已经报名人数
@property (nonatomic, copy) NSString *enrollmentNumber;
// 活动花费
@property (nonatomic, copy) NSString *activityCosts;
// 联系人
@property (nonatomic, copy) NSString *contactPerson;
// 联系电话
@property (nonatomic, copy) NSString *contactNumber;
// 内容
@property (nonatomic, copy) NSString *content;
// 是否已参加
@property (nonatomic, assign) BOOL isParticipate;
// 是否已关闭 0-未关闭 1-已关闭
@property (nonatomic, copy) NSString *isClosed;
// 是否已结束 0-未结束 1-已结束
@property (nonatomic, copy) NSString *isEnd;
// 封面图片
@property (nonatomic, strong) XDResourceModel *coverImageResource;

@end

NS_ASSUME_NONNULL_END
