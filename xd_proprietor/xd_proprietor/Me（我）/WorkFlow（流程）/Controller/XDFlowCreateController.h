//
//  Created by cfsc on 2020/4/7.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XDFlowCreateControllerType) {
    // 工单
    XDFlowCreateControllerTypeOrder,
    // 投诉
    XDFlowCreateControllerTypeComplain,
    // 筛选
    XDFlowCreateControllerTypeFilter,
    // 评价
    XDFlowCreateControllerTypeEvaluate
};

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowCreateController : UIViewController

@property (assign, nonatomic) XDFlowCreateControllerType type;

@end

NS_ASSUME_NONNULL_END
