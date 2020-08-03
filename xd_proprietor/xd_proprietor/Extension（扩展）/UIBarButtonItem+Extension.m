//
//  UIBarButtonItem+Extension.m
//  FOXSport
//
//  Created by FOX on 15-10-8.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)leftItemWithImageName:(NSString *)imageName frame:(CGRect )frame target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //    button.backgroundColor=[UIColor redColor];
    // 设置按钮的尺寸为背景图片的尺寸
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName frame:(CGRect )frame target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    button.backgroundColor=[UIColor redColor];
    // 设置按钮的尺寸为背景图片的尺寸
    button.frame=frame;
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title frame:(CGRect )frame target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:litterBackColor forState:UIControlStateHighlighted];
    button.titleLabel.font = CFont(16, 14);
    [button sizeToFit];
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


@end

