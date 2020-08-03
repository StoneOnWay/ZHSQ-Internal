//
//  Created by cfsc on 2020/3/28.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowFormModel : NSObject

// 表单对应key
@property (nonatomic, copy) NSString *formKey;
// 表单元素类型
@property (nonatomic, copy) NSString *formItemType;
// 表单元素标题
@property (nonatomic, copy) NSString *formItemLabel;
// 表单需要显示的字段名
@property (nonatomic, copy) NSString *fieldName;
// 排序
@property (nonatomic, copy) NSString *sort;
// 校验
@property (assign, nonatomic) BOOL required;
@property (copy, nonatomic) NSArray *valid;

@end

NS_ASSUME_NONNULL_END
