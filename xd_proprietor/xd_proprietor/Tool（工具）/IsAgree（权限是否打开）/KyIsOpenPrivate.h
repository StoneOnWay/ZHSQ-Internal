//
//  KyIsOpenPrivate.h
//  XD业主
//
//  Created by zc on 2017/7/20.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KyIsOpenPrivate : NSObject

+ (instancetype)sharedManager;
/**
 *  是否打开相册的权限
 */
- (BOOL)isAllowPrivacyLibrary;
/**
 *  是否打开相机的权限
 */
- (BOOL)isAllowPrivacyCamera;
/**
 *  是否打开联系人的权限
 */
- (BOOL)isAllowPrivacyContact;
@end
