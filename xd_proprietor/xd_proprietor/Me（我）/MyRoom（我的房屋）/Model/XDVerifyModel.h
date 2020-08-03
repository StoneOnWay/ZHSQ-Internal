//
//  Created by cfsc on 2020/4/15.
//  Copyright © 2020 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDVerifyModel : NSObject
// id
@property (nonatomic, copy) NSString *verifyId;
// 房屋业主id
@property (nonatomic, copy) NSString *householdId;
// 房屋id
@property (nonatomic, copy) NSString *roomId;
// 提交审核人电话
@property (nonatomic, copy) NSString *mobile;
// 提交审核人类型
@property (nonatomic, copy) NSString *type;
// 备注信息
@property (nonatomic, copy) NSString *remark;
// 审核状态
@property (nonatomic, copy) NSString *status;
// 提交审核时间
@property (nonatomic, copy) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
