//
//  Created by cfsc on 2020/3/19.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDFlowProcessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowDetailModel : NSObject
// 类型
@property (nonatomic, copy) NSString *flowType;
// 创建人
@property (nonatomic, copy) NSString *createName;
// 创建人头像url
@property (nonatomic, copy) NSString *creatorAvatarUrl;
// 简单描述
@property (nonatomic, copy) NSString *briefDesc;
// 地址
@property (nonatomic, copy) NSString *address;
// 工单类型
@property (nonatomic, copy) NSString *workTypeName;
// 投诉类型
@property (nonatomic, copy) NSString *complaintTypeName;
// 工单状态
@property (nonatomic, copy) NSString *workStatusName;
// 项目id
@property (nonatomic, copy) NSString *projectId;
// 项目名称
@property (nonatomic, copy) NSString *projectName;
// 分期名称
@property (nonatomic, copy) NSString *phaseName;
// 业主名称
@property (nonatomic, copy) NSString *householdName;
// 业主电话
@property (nonatomic, copy) NSString *householdMobile;
// 联系人
@property (nonatomic, copy) NSString *linkMan;
// 联系电话
@property (nonatomic, copy) NSString *mobile;
// 问题描述
@property (nonatomic, copy) NSString *problemDesc;
// 创建时间
@property (nonatomic, copy) NSString *createTime;
// 是否完成
@property (nonatomic, copy) NSString *isFinish;
// 材料费
@property (nonatomic, copy) NSString *materialsCost;
// 人工费
@property (nonatomic, copy) NSString *manualCost;
// 解决方案
@property (nonatomic, copy) NSString *solutionContent;
// 整改措施
@property (nonatomic, copy) NSString *reformMeasures;
// 操作数组
@property (nonatomic, copy) NSArray <XDFlowProcessModel *>*processes;
// 流程图片资源
@property (nonatomic, copy) NSArray <XDResourceModel *>*problemResourceValue;
@end

NS_ASSUME_NONNULL_END
