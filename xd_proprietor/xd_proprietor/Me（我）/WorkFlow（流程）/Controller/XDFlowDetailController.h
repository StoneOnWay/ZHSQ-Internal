//
//  Created by cfsc on 2020/3/2.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDFlowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowDetailController : UIViewController
@property (nonatomic, strong) XDFlowModel *flow;
// 流程类型
@property (nonatomic, assign) XDFlowType flowType;
@property (nonatomic, copy) void (^didUpdateFlowNode)(void);
@end

NS_ASSUME_NONNULL_END
