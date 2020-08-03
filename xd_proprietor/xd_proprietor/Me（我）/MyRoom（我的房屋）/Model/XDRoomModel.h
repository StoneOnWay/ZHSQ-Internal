//
//  Created by cfsc on 2020/3/10.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface XDRoomModel : NSObject <NSCoding>

// id
@property (nonatomic, copy) NSString *roomId;
// 项目名
@property (nonatomic, copy) NSString *projectName;
// 全名
@property (nonatomic, copy) NSString *fullName;
// 房屋编码
@property (nonatomic, copy) NSString *code;
// 名称
@property (nonatomic, copy) NSString *name;
// 项目ID
@property (nonatomic, copy) NSString *projectId;
// 分期ID
@property (nonatomic, copy) NSString *phaseId;
// 楼栋ID
@property (nonatomic, copy) NSString *buildingId;
// 单元ID
@property (nonatomic, copy) NSString *unitId;
// 房屋住户列表
@property (nonatomic, copy) NSArray <XDUserModel *>*householdBoList;

/**** room实体以外的字段 ****/
// 住户类型
@property (nonatomic, copy) NSString *householdType;
// 对应住户类型
@property (nonatomic, copy) NSString *householdTypeDisplay;
// 审核状态 1-待审核 2-审核通过 3-审核不通过
@property (nonatomic, assign) NSInteger approvalStatus;
// 审核记录id
@property (nonatomic, copy) NSString *approvalId;
// 是否入伙
@property (nonatomic, copy) NSString *joinStatus;

@end

NS_ASSUME_NONNULL_END
