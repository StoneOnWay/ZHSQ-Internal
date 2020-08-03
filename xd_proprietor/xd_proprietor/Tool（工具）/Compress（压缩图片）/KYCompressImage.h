//
//  KYCompressImage.h
//  XD业主
//
//  Created by zc on 2017/8/15.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYCompressImage : NSObject

+ (NSData *)compressImage:(NSData *)data toByte:(NSUInteger)maxLength;

@end
