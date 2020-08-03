//
//  UIBarButtonItem+Extension.h
//  FOXSport
//
//  Created by FOX on 15-10-8.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)leftItemWithImageName:(NSString *)imageName frame:(CGRect )frame target:(id)target action:(SEL)action;
//设置导航栏的item
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName frame:(CGRect )frame target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title frame:(CGRect )frame target:(id)target action:(SEL)action;
@end
