//
//  Created by cfsc on 2020/3/19.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowListController : UITableViewController

// 流程类型
@property (nonatomic, assign) XDFlowType flowType;
// 状态
@property (nonatomic, assign) XDFlowStatus flowStatus;

@end

NS_ASSUME_NONNULL_END
