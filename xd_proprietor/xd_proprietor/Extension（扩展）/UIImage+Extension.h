//
//  UIImage+Extension.h
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 *  UIColor转化成UIImage对象
 */
+(UIImage*) createImageWithColor:(UIColor*) color;


/**
 压缩图片到指定长度和大小

 @param size 图片size
 @param maxLength 图片数据字节长度
 @return 图片数据
 */
- (NSData *)compressBySize:(CGSize)size WithMaxLength:(NSUInteger)maxLength;

// 生成一张虚线图片
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

@end
