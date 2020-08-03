//
//  AppDelegate.h
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) BaseTabBarViewController *tabBarViewController;
/// func
+ (AppDelegate* )shareAppDelegate;
/**
 *  获取当前窗口的跟控制器
 */
- (UIViewController *)topVC:(UIViewController *)rootViewController;

@end

