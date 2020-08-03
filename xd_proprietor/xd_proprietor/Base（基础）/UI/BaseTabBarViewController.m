//
//  BaseTabBarViewController.m
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "XDHomePageViewController.h"
#import "XDMyViewController.h"
#import "XDCustomTabBar.h"
#import "XDRemoteOpenController.h"
#import "XDMaskingTipController.h"

@interface BaseTabBarViewController ()<UITabBarControllerDelegate, XDTabBarDelegate>

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCustomTabBar];
    
    self.delegate = self;
    
    //设置tabbar的背景
    self.hidesBottomBarWhenPushed = YES;

    [self initChildViewControllers];
}

- (void)setUpCustomTabBar {
    // 创建自定义TabBar
    XDCustomTabBar *myTabBar = [[XDCustomTabBar alloc] init];
    myTabBar.myTabBarDelegate = self;
    // 利用KVC替换默认的TabBar
    [self setValue:myTabBar forKey:@"tabBar"];
    
//    if (@available(iOS 13, *)) {
//        UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
//        appearance.backgroundImage = [UIImage imageWithColor:RGB(236, 236, 236)];
//        appearance.shadowImage = [UIImage imageWithColor:RGB(236, 236, 236)];
//        // 官方文档写的是 重置背景和阴影为透明
//        [appearance configureWithTransparentBackground];
//        self.tabBar.standardAppearance = appearance;
//    } else {
//        self.tabBar.backgroundImage = [UIImage imageWithColor:RGB(236, 236, 236)];
//        self.tabBar.shadowImage = [UIImage imageWithColor:RGB(236, 236, 236)];
//    }
    self.tabBar.tintColor = RGB(44, 52, 71);
    self.tabBar.barTintColor = RGB(236, 236, 236);
}

- (void)initChildViewControllers {
    NSMutableArray *childVCArray = [[NSMutableArray alloc] initWithCapacity:3];
    // 添加两个子控件
    XDHomePageViewController *homeVC = [[XDHomePageViewController alloc] init];
    [self setViewController:homeVC title:@"首页" normalImage:@"btn_tab_home_nor" selectedImage:@"btn_tab_home_sel" vcList:childVCArray];
    
    XDMyViewController *ownVC = [[XDMyViewController alloc] init];
    ownVC.tabBarController.delegate = self;
    [self setViewController:ownVC title:@"我" normalImage:@"btn_tab_my_nor" selectedImage:@"btn_tab_my_sel" vcList:childVCArray];
   
    self.viewControllers = childVCArray;
}

- (void)setViewController:(UIViewController *)vc title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage vcList:(NSMutableArray *)vcList {
    [vc.tabBarItem setTitle:title];
    [vc.tabBarItem setImage:[UIImage imageNamed:normalImage]];
    [vc.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImage]];
    BaseNavigationController *discoverNavC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [vcList addObject:discoverNavC];
}

#pragma mark - MyTabBarDelegate
- (void)openButtonClick:(XDCustomTabBar *)tabBar {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (loginInfo.userModel.currentDistrict.joinStatus.integerValue != 1) {
        [XDUtil showToast:@"您还未入伙，无法使用一键开门功能"];
    } else {
        UIViewController *rootVC = [[AppDelegate shareAppDelegate] topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
        XDRemoteOpenController *openVC = [[XDRemoteOpenController alloc] init];
//        openVC.modalPresentationStyle = 0;
        openVC.modalPresentationCapturesStatusBarAppearance = YES;
        [rootVC presentViewController:openVC animated:YES completion:nil];
    }
}

- (void)showMaskingTip {
    // 弹出提示选择房屋
    XDMaskingTipController *maskVC = [[XDMaskingTipController alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        maskVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    } else {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [self presentViewController:maskVC animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
