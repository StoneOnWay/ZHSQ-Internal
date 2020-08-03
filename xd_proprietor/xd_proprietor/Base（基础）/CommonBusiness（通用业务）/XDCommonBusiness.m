//
//  Created by cfsc on 2020/4/23.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDCommonBusiness.h"
#import "XDLoginViewController.h"
#import "XDProjectSelectController.h"

@interface XDCommonBusiness () <CustomAlertViewDelegate>

@end

@implementation XDCommonBusiness

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static XDCommonBusiness *business;
    dispatch_once(&onceToken, ^{
        business = [[XDCommonBusiness alloc] init];
    });
    return business;
}

- (void)setPushTagsAndAlias {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    // 设置推送别名
    NSString *string = [NSString stringWithFormat:@"%@", loginInfo.userModel.userID];
    [JPUSHService setAlias:string completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"设置别名-%ld", (long)iResCode);
    } seq:1];
    NSMutableSet *set = [[NSMutableSet alloc] init];
    [set addObject:[self getCurrentUserType]];
//    [set addObject:@"YZ"];
    // “p_”拼接业主当前项目id
    [set addObject:[NSString stringWithFormat:@"P_%@", loginInfo.userModel.currentDistrict.projectId]];
    [JPUSHService setTags:set completion:nil seq:1];
}

- (void)cleanPushTagsAndAlias {
    // 清空推送别名和标签
    [JPUSHService cleanTags:nil seq:1];
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"清空别名-%ld", (long)iResCode);
    } seq:1];
}

- (NSString *)getCurrentUserType {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    // 身份（业主使用个当前身份，YZ\JS\ZH...）
    NSString *type = @"YK";
    for (XDRoomModel *room in loginInfo.userModel.roomList) {
        if ([room.roomId isEqualToString:loginInfo.userModel.currentDistrict.roomId]) {
            type = room.householdType;
        }
    }
    return type;
}

- (void)updateWithAppStoreVersion {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    [[XDRequstManager sharedManager] POST:@"https://itunes.apple.com/lookup?id=1470360494" parameters:nil succend:^(id resp) {
        if (resp) {
            NSArray *array = resp[@"results"];
            NSString *nowVersion = nil;
            for (NSDictionary *dic in array) {
                if ([dic.allKeys containsObject:@"version"]) {
                    nowVersion = dic[@"version"];
                }
            }
            if (nowVersion && ![currentVersion isEqualToString:nowVersion]) {
                NSString *msg = [NSString stringWithFormat:@"有新版本%@，是否更新？", nowVersion];
                UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"更新" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1470360494"];
                    [[UIApplication sharedApplication] openURL:url];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertvc addAction:sureAction];
                [alertvc addAction:cancelAction];
                UIViewController *rootVC = [[AppDelegate shareAppDelegate] topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
                [rootVC.navigationController presentViewController:alertvc animated:YES completion:nil ];
            }
        }
    } fail:^(NSError *errors) {
        
    }];
}

- (void)goToLoginVC {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XDLoginViewController *logon = [storyboard instantiateViewControllerWithIdentifier:@"XDLoginViewController"];
    BaseNavigationController *loginNav = [[BaseNavigationController alloc] initWithRootViewController:logon];
    window.rootViewController = loginNav;
}

- (void)goToRootViewController {
    // 获取登录信息
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (loginInfo) {
        if (!loginInfo.userModel.currentDistrict.projectId) {
            // 跳转至项目选择
            XDProjectSelectController *projectSelectVC = [[XDProjectSelectController alloc] init];
            projectSelectVC.canGoBack = NO;
            [AppDelegate shareAppDelegate].window.rootViewController = projectSelectVC;
        } else {
            // 进入首页
            [AppDelegate shareAppDelegate].tabBarViewController = [[BaseTabBarViewController alloc] init];
            [AppDelegate shareAppDelegate].window.rootViewController = [AppDelegate shareAppDelegate].tabBarViewController;
        }
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        XDLoginViewController *logon = [storyboard instantiateViewControllerWithIdentifier:@"XDLoginViewController"];
        BaseNavigationController *loginNav = [[BaseNavigationController alloc] initWithRootViewController:logon];
        [AppDelegate shareAppDelegate].window.rootViewController = loginNav;
    }
}

#pragma mark - login out
// 退出登录
- (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:@"取消" andOtherTitle:@"确定" andIsOneBtn:NO];
    [alertView.otherButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    alertView.delegate = self;
    [window addSubview:alertView];
}

// CustomAlertViewDelegate
- (void)clickButtonWithTag:(UIButton *)button {
    if (button.tag == 309) {
        [MBProgressHUD showActivityMessageInView:nil];
        // 清除登录信息
        XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
        loginInfo = nil;
        [XDArchiverManager saveLoginInfo:loginInfo];
        [[XDCommonBusiness shareInstance] cleanPushTagsAndAlias];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [[XDCommonBusiness shareInstance] goToLoginVC];
        });
    }
}

@end
