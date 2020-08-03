//
//  XDDoPaymentController.h
//  xd_proprietor
//
//  Created by stone on 28/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDBillModel, XDCarCharterModel;
NS_ASSUME_NONNULL_BEGIN

@interface XDDoPaymentController : UITableViewController
@property (nonatomic, strong) XDBillModel *bill;
@property (nonatomic, strong) XDCarCharterModel *charter;
@property (nonatomic, copy) void ((^hasPaidBlock)(void));
@end

NS_ASSUME_NONNULL_END
