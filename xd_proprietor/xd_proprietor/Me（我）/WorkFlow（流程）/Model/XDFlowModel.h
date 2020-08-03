//
//  Created by cfsc on 2020/3/19.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDResourceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowModel : NSObject
// id
@property (nonatomic, copy) NSString *flowId;
// 流程类型 eg:厨卫维修
@property (nonatomic, copy) NSString *typeName;
// 流程状态 eg:客服接单
@property (nonatomic, copy) NSString *statusName;
// 问题描述
@property (nonatomic, copy) NSString *problemDesc;
// 流程创建时间
@property (nonatomic, copy) NSString *createTime;
// 创建人
@property (nonatomic, copy) NSString *creator;
// 简短描述
@property (nonatomic, copy) NSString *briefDesc;
// 地址
@property (nonatomic, copy) NSString *address;
// 流程图片资源
@property (nonatomic, copy) NSArray<XDResourceModel *> *problemResourceValue;
@end

NS_ASSUME_NONNULL_END
