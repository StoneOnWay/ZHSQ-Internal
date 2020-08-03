//
//  Created by cfsc on 2020/4/21.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDCustomTabBar;

NS_ASSUME_NONNULL_BEGIN

// XDTabBar的代理必须实现addButtonClick，以响应中间“+”按钮的点击事件
@protocol XDTabBarDelegate <NSObject>

- (void)openButtonClick:(XDCustomTabBar *)tabBar;

@end

@interface XDCustomTabBar : UITabBar

//指向XDTabBar的代理
@property (nonatomic, weak) id<XDTabBarDelegate> myTabBarDelegate;

@end

NS_ASSUME_NONNULL_END
