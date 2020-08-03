//
//  AppDelegate.m
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "AppDelegate.h"
#import "XDLoginViewController.h"
#import "XDInfoNewDetailNetController.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import "XDCallCenterBusiness.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XDCallCenterController.h"
#import "XDProjectSelectController.h"
#import "XDFlowDetailController.h"
#import "XDPageContainerController.h"
#import "XDRoomVerifyController.h"
#import "XDCarListController.h"
#import "XDGuidePagesController.h"
#import "CALayer+Transition.h"
#import "XDAdvertController.h"

#define JPUSH_APPKEY @"9d5199c1d83613fa2ccaffb8"
#define CHANNEL @"Develop channel"

@interface AppDelegate ()<JPUSHRegisterDelegate,CustomAlertViewDelegate,XDGuidePagesControllerDelegate>

@property(nonatomic ,copy)NSString *downUrl;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // 拍照用的同一个框架 有些地方是三个 有些地方是九个
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"kMaxImageCount"];
    
    // 初始化本地IP
    [TheUserDefaults setObject:KTestIp forKey:@"server_ip"];
    NSString *string = KServerIp;
    if (string.length == 0) {
        [TheUserDefaults setObject:KProuductionIp forKey:@"server_ip"];
    }
    
    // 引导页
    NSArray *images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3"];
    BOOL shouldShow = [XDGuidePagesController shouldShow];
//    shouldShow = YES;
    if (shouldShow) {
        XDGuidePagesController *xtVC = [[XDGuidePagesController alloc] init];
        self.window.rootViewController = xtVC;
        xtVC.delegate = self;
        [xtVC guidePageControllerWithImages:images];
    } else {
        XDAdvertController *avertVC = [[XDAdvertController alloc] init];
        self.window.rootViewController = avertVC;
    }
    
#pragma mark 极光推送
    // notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY channel:@"App Store" apsForProduction:YES];
    
#pragma mark AppStore版本更新
    [[XDCommonBusiness shareInstance] updateWithAppStoreVersion];
    
    // U-Share 平台设置
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    [[XDCallCenterBusiness sharedInstance] initialHikSdk:^(BOOL success) {
        if (!success) {
            NSLog(@"SDK初始化失败！");
        }
    }];
    
    return YES;
}

- (void)clickEnter {
    [[XDCommonBusiness shareInstance] goToRootViewController];
    [self.window.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:2.0f];
}

- (void)confitUShareSettings {
    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:@"5cc6b9754ca3577ea20001c2" channel:@"App Store"];
    // 打开图片水印
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)configUSharePlatforms {
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx9e26096ae63f011d" appSecret:@"22ba1246fa64314bb6cc97a7c10ac25c" redirectURL:nil];
    
    // 移除相应平台的分享，如微信收藏
    //    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101569547"/*设置QQ平台的appID*/  appSecret:@"00261965102559b4d8732e9a747c771a" redirectURL:nil];
}

#pragma mark - 推送处理
// ios 10 support 处于前台时接收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if (userInfo) {
            //            [self goToJPushControllerWithDic:userInfo];
            [self showPushAlertWithDic:userInfo];
            [JPUSHService handleRemoteNotification:userInfo];
            completionHandler(UIBackgroundFetchResultNewData);
        }
    }
    //    completionHandler(UNNotificationPresentationOptionAlert);
    // 处于前台时，添加需求，一般是弹出alert跟用户进行交互，这时候completionHandler(UNNotificationPresentationOptionAlert)这句话就可以注释掉了，这句话是系统的alert，显示在app的顶部，
}

- (void)showPushAlertWithDic:(NSDictionary *)userInfo {
    UIViewController *rootVC = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    NSString *msg = userInfo[@"aps"][@"alert"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([userInfo[@"type"] isEqualToString:@"1005"]) {
            // 业主审核结果
            // 更新本地用户信息
            XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
            [XDHTTPRequst getUserInfoCacheSucceed:^(id res) {
                if ([res[@"code"] integerValue] == 200) {
                    XDUserModel *userModel = [XDUserModel mj_objectWithKeyValues:res[@"result"]];
                    loginInfo.userModel = userModel;
                    [XDArchiverManager saveLoginInfo:loginInfo];
                    [[XDCommonBusiness shareInstance] setPushTagsAndAlias];
                }
            } fail:^(NSError *error) {
                
            }];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"前往查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goToJPushControllerWithDic:userInfo];
    }]];
    if ([userInfo[@"type"] isEqualToString:@"1001"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidPublishNewsNotification" object:nil];
    } else if ([userInfo[@"type"] isEqualToString:@"1010"]) {
        [self goToJPushControllerWithDic:userInfo];
    } else {
        [rootVC presentViewController:alert animated:YES completion:nil];
    }
}

// iOS 10 Support  点击处理事件
/**
 *  极光通知被点击
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        // 推送打开
        if (userInfo) {
            [self goToJPushControllerWithDic:userInfo];
            [JPUSHService handleRemoteNotification:userInfo];
            completionHandler(UIBackgroundFetchResultNewData);
        }
        completionHandler(UNNotificationPresentationOptionBadge); // 系统要求执行这个方法
    }
}

- (void)goToJPushControllerWithDic:(NSDictionary *)userInfo {
    //拿到当前页面的VC
    UIViewController *rootVC = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    if ([userInfo[@"type"] isEqualToString:@"1001"]) {
        // 新闻公告
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidPublishNewsNotification" object:nil];
        XDInfoNewDetailNetController *info = [[XDInfoNewDetailNetController alloc] init];
        XDContentInfoModel *model = [[XDContentInfoModel alloc] init];
        model.contentID = userInfo[@"businessId"];
        info.infoModel = model;
        [rootVC.navigationController pushViewController:info animated:YES];
    } else if ([userInfo[@"type"] isEqualToString:@"1002"]) {
        // 工单
        XDFlowDetailController *flow = [[XDFlowDetailController alloc] init];
        XDFlowModel *flowModel = [[XDFlowModel alloc] init];
        flowModel.flowId = userInfo[@"businessId"];
        flow.flow = flowModel;
        flow.flowType = XDFlowTypeOrder;
        [rootVC.navigationController pushViewController:flow animated:YES];
    } else if ([userInfo[@"type"] isEqualToString:@"1003"]) {
        // 投诉
        XDFlowDetailController *flow = [[XDFlowDetailController alloc] init];
        XDFlowModel *flowModel = [[XDFlowModel alloc] init];
        flowModel.flowId = userInfo[@"businessId"];
        flow.flow = flowModel;
        flow.flowType = XDFlowTypeComplain;
        [rootVC.navigationController pushViewController:flow animated:YES];
    } else if ([userInfo[@"type"] isEqualToString:@"1004"]) {
        // 业主待审核
        XDRoomVerifyController *roomVerifyVC = [[XDRoomVerifyController alloc] init];
        XDRoomModel *roomModel = [[XDRoomModel alloc] init];
        roomModel.roomId = userInfo[@"businessId"];
        roomVerifyVC.roomModel = roomModel;
        [rootVC.navigationController pushViewController:roomVerifyVC animated:YES];
    } else if ([userInfo[@"type"] isEqualToString:@"1005"]) {
        // 业主审核通过
        // 更新本地用户信息并进入我的房屋界面
        [MBProgressHUD showActivityMessageInView:nil];
        XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
        [XDHTTPRequst getUserInfoCacheSucceed:^(id res) {
            [MBProgressHUD hideHUD];
            if ([res[@"code"] integerValue] == 200) {
                XDUserModel *userModel = [XDUserModel mj_objectWithKeyValues:res[@"result"]];
                loginInfo.userModel = userModel;
                [XDArchiverManager saveLoginInfo:loginInfo];
                [[XDCommonBusiness shareInstance] setPushTagsAndAlias];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"XDPageContainerController" bundle:nil];
                XDPageContainerController *pageVC = [storyboard instantiateViewControllerWithIdentifier:@"XDPageContainerController"];
                [rootVC.navigationController pushViewController:pageVC animated:YES];
            } else {
                [MBProgressHUD showTipMessageInWindow:res[@"message"] timer:2];
            }
        } fail:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [XDHTTPRequst showErrorMessageWith:error];
        }];
    } else if ([userInfo[@"type"] isEqualToString:@"1006"]) {
        // 业主审核不通过，直接进入其他房屋界面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"XDPageContainerController" bundle:nil];
        XDPageContainerController *pageVC = [storyboard instantiateViewControllerWithIdentifier:@"XDPageContainerController"];
        pageVC.toVC = @"XDOtherRoomController";
        [rootVC.navigationController pushViewController:pageVC animated:YES];
    } else if ([userInfo[@"type"] isEqualToString:@"1008"]) {
        // 车辆审核通过
        XDCarListController *carList = [[XDCarListController alloc] init];
        [rootVC.navigationController pushViewController:carList animated:YES];
    } else if ([userInfo[@"type"] isEqualToString:@"1010"]) {
        // 呼叫
        XDCallCenterBusiness *business = [XDCallCenterBusiness sharedInstance];
        CloudVoiceTalkParamsModel *talkModel = [[CloudVoiceTalkParamsModel alloc] init];
        talkModel.deviceSerial = userInfo[@"deviceSerial"];
        NSString *room = nil;
        if ([userInfo[@"roomNumber"] intValue] < 10) {
            room = [NSString stringWithFormat:@"%@0%@", userInfo[@"floorNumber"], userInfo[@"roomNumber"]];
        } else {
            room = [NSString stringWithFormat:@"%@%@", userInfo[@"floorNumber"], userInfo[@"roomNumber"]];
        }
        talkModel.room = room;
        talkModel.callId = @"";
        talkModel.periodNumber = [NSString stringWithFormat:@"%@", userInfo[@"periodNumber"]];
        talkModel.buildingNumber = [NSString stringWithFormat:@"%@", userInfo[@"buildingNumber"]];
        talkModel.unitNumber = [NSString stringWithFormat:@"%@", userInfo[@"unitNumber"]];
        talkModel.floorNumber = [NSString stringWithFormat:@"%@", userInfo[@"floorNumber"]];
        talkModel.devIndex = [NSString stringWithFormat:@"%@", userInfo[@"devIndex"]];
        talkModel.unitType = userInfo[@"unitType"];
        business.talkModel = talkModel;
        XDCallCenterController *callVC = [[XDCallCenterController alloc] init];
        [business initialHikSdk:^(BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [rootVC.navigationController pushViewController:callVC animated:YES];
                });
            }
        }];
    }
}

- (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

/**
 *  获取当前窗口的跟控制器
 */
- (UIViewController *)topVC:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[BaseTabBarViewController class]]) {
        BaseTabBarViewController *tab = (BaseTabBarViewController *)rootViewController;
        return [self topVC:tab.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        BaseNavigationController *navc = (BaseNavigationController *)rootViewController;
        return [self topVC:navc.visibleViewController];
    }else if (rootViewController.presentedViewController){
        UIViewController *pre = (UIViewController *)rootViewController.presentedViewController;
        return [self topVC:pre];
    }else{
        return rootViewController;
    }
}

/**
 *  Required - 注册 DeviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

// 处理推送过来的消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"推送的消息呢===%@", userInfo);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// 点击之后badge清零
- (void)applicationDidEnterBackground:(UIApplication *)application {
    dispatch_async(dispatch_get_main_queue(), ^{
        [JPUSHService setBadge:0];
        [[UIApplication alloc] setApplicationIconBadgeNumber:0];
    });
}

// 点击之后badge清零
- (void)applicationWillEnterForeground:(UIApplication *)application {
    dispatch_async(dispatch_get_main_queue(), ^{
        [JPUSHService setBadge:0];
        [[UIApplication alloc] setApplicationIconBadgeNumber:0];
    });
    [[UNUserNotificationCenter alloc] removeAllPendingNotificationRequests];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    return result;
}

- (void)onDBMigrateStart {
    NSLog(@"onDBmigrateStart in appdelegate");
}

/**
 *  获取delegate
 */
+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


@end
