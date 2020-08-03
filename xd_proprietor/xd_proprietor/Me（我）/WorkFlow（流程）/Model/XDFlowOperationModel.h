//
//  Created by cfsc on 2020/3/28.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowOperationModel : NSObject

// 名称
@property (nonatomic, copy) NSString *name;
// 选择
@property (nonatomic, copy) NSString *choose;
// 操作id
@property (nonatomic, copy) NSString *operationId;
// 详细
@property (nonatomic, copy) NSString *desc;

@end

NS_ASSUME_NONNULL_END
