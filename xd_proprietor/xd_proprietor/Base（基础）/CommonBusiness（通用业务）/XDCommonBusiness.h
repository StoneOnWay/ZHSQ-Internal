//
//  Created by cfsc on 2020/4/23.
//  Copyright © 2020 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDCommonBusiness : NSObject

+ (instancetype)shareInstance;

/**
 设置推送别名和标签
 */
- (void)setPushTagsAndAlias;

/**
 清空推送别名和标签
 */
- (void)cleanPushTagsAndAlias;

/// 获取当前登录用户类型
- (NSString *)getCurrentUserType;

/// 更新版本
- (void)updateWithAppStoreVersion;

/// 跳转到登录界面
- (void)goToLoginVC;

/// 根据登录信息选择以某个控制器为显示
- (void)goToRootViewController;

// 退出登录
- (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle;

@end

NS_ASSUME_NONNULL_END
