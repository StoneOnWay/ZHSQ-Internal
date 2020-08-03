//
//  Created by cfsc on 2020/3/19.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XDResourceModel;

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowProcessModel : NSObject
// 处理人
@property (nonatomic, copy) NSString *handlerName;
// 指派人ID
@property (nonatomic, copy) NSString *assigneeId;
// 头像Url
@property (nonatomic, copy) NSString *avatarUrl;
// 简单描述
@property (nonatomic, copy) NSString *briefDesc;
// 处理人手机号
@property (nonatomic, copy) NSString *handlerMobile;
// 描述
@property (nonatomic, copy) NSString *remark;
// 解决方案
@property (nonatomic, copy) NSString *content;
// 期望时间
@property (nonatomic, copy) NSString *contentDate;
// 评分
@property (nonatomic, copy) NSString *commentLevel;
// 节点名称
@property (nonatomic, copy) NSString *nodeName;
// 创建时间
@property (nonatomic, copy) NSString *createTime;
// 流程图片资源
@property (nonatomic, copy) NSArray<XDResourceModel *> *resourceValue;
// 流程处理操作
@property (nonatomic, copy) NSArray *operationInfos;
// 表单内容
@property (nonatomic, copy) NSArray *formContent;

@end

NS_ASSUME_NONNULL_END
