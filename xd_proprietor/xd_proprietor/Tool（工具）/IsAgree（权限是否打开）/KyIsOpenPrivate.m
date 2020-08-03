//
//  KyIsOpenPrivate.m
//  XD业主
//
//  Created by zc on 2017/7/20.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "KyIsOpenPrivate.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBook/AddressBook.h>

@interface KyIsOpenPrivate()<CustomAlertViewDelegate>

@end
@implementation KyIsOpenPrivate

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static KyIsOpenPrivate *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
    
}

/**
 *  调用系统相册
 */
- (BOOL)isAllowPrivacyLibrary {

    
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (authStatus == ALAuthorizationStatusDenied||authStatus == ALAuthorizationStatusRestricted) {
        [[KyIsOpenPrivate sharedManager] clickToAlertViewTitle:@"西府需要访问您的相册" withDetailTitle:@"只有允许访问您的相册才能够添加照片"];
        return NO;;
    }
    return YES;
}

/**
 *  调用系统相机
 */
- (BOOL)isAllowPrivacyCamera {

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied||authStatus == AVAuthorizationStatusRestricted) {
        
        [[KyIsOpenPrivate sharedManager] clickToAlertViewTitle:@"西府需要访问您的相机" withDetailTitle:@"只有允许访问您的相机才能拍照上传"];
        return NO;
    }
    
    return YES;

}
/**
 *  是否打开联系人的权限
 */
- (BOOL)isAllowPrivacyContact {
    
    
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus == kABAuthorizationStatusDenied||authStatus == kABAuthorizationStatusRestricted) {
        
        [[KyIsOpenPrivate sharedManager] clickToAlertViewTitle:@"西府需要访问您的通讯录" withDetailTitle:@"只有允许访问您的通讯录才能选择联系人"];
        return NO;
    }
    
    return YES;
    
}


- (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle
{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:@"取消" andOtherTitle:@"设置" andIsOneBtn:NO];
    alertView.delegate = self;
    [window addSubview:alertView];
    
}

- (void)clickButtonWithTag:(UIButton *)button {

    if (button.tag == 308) {
        //取消
        NSLog(@"取消");
        
    }else {
        //确定
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        NSLog(@"确定");
    }

}

@end
