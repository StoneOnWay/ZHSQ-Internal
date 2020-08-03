//
//  Created by cfsc on 2020/7/17.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDDevicePermissionController : UIViewController

@property (nonatomic, strong) XDUserModel *userModel;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *phaseId;
@property (nonatomic, strong) NSMutableArray *permissionArray;
@property (nonatomic, copy) NSString *errorTipStr;

@end

NS_ASSUME_NONNULL_END
