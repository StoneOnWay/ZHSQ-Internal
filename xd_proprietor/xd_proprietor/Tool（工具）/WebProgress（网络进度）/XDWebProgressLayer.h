//
//  XDWebProgressLayer.h
//  XD业主
//
//  Created by zc on 2017/6/24.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface XDWebProgressLayer : CAShapeLayer

// 开始加载
- (void)startLoad;
// 完成加载
- (void)finishedLoadWithError:(NSError *)error;
// 关闭时间
- (void)closeTimer;

- (void)wkWebViewPathChanged:(CGFloat)estimatedProgress;


@end
