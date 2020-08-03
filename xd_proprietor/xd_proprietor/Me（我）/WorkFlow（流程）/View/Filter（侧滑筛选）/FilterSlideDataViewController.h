//
//  FilterSlideViewController.h
//  Vasse
//
//  Created by 饶首建 on 16/5/19.
//  Copyright © 2016年 voossi. All rights reserved.
//

#import "CustomSlideBar.h"
#import "HZSingleChoiceModel.h"

@interface FilterSlideDataViewController : CustomSlideBar

@property (nonatomic, copy) void (^backBlock)(id backData);
@property (nonatomic, assign) XDFlowType flowType;
@property (nonatomic, strong) HZSingleChoiceModel *completeStatusChoice; // 选择的完成状态
@property (nonatomic, strong) HZSingleChoiceModel *typeChoice; // 选择的类型
@property (nonatomic, strong) HZSingleChoiceModel *flowStatusChoice; // 选择的流程状态

@end
