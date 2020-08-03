//
//  XDImagePickerController.m
//  xd_proprietor
//
//  Created by stone on 26/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDImagePickerController.h"
#import "XDOverlayView.h"

@interface XDImagePickerController ()

@end

@implementation XDImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth- 40, 20)];
//    tip.text = @"请保证光线充足，正面拍摄，睁眼";
//    tip.font = [UIFont systemFontOfSize:14];
//    tip.textAlignment = NSTextAlignmentCenter;
//    tip.textColor = [UIColor whiteColor];
//    [overlay addSubview:tip];
//    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenWidth)];
//    back.image = [UIImage imageNamed:@"face_limit"];
//    [overlay addSubview:back];
//    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    btn.frame = CGRectMake(kScreenWidth / 2 - 20, kScreenHeight - 60, 40, 20);
//    [btn setTitle:@"拍照" forState:(UIControlStateNormal)];
//    [btn addTarget:self action:@selector(takePhoto) forControlEvents:(UIControlEventTouchUpInside)];
//    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [overlay addSubview:btn];
//    self.cameraOverlayView = overlay;
    
    CGSize screenBounds = [UIScreen mainScreen].bounds.size;
    CGFloat cameraAspectRatio = 4.0f/3.0f;
    CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
    CGFloat scale = screenBounds.height / camViewHeight;
    self.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
    self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform, scale, scale);   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

// 递归获取子视图
- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    // 如果没有子视图就直接返回
    if ([subviews count] == 0) return;
    for (UIView *subview in subviews) {
        // 根据层级决定前面空格个数，来缩进显示
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        // 打印子视图类名
        NSLog(@"subview ---- %@%d: %@", blank, level, subview.class);
//        if ([subview isKindOfClass:NSClassFromString(@"CUShutterButton")]) {
//            UIButton *btn = (UIButton *)subview;
//            [btn addTarget:self action:@selector(takePictureBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
//        }
        // 递归获取此视图的子视图
        [self getSub:subview andLevel:(level+1)];
    }
}

@end
