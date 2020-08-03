//
//  BaseNavigationController.m
//  ScreenShotBack
//
//  Created by 郑文明 on 16/5/10.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>
{
    NSString *_title;

}
@end

@implementation BaseNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.interactivePopGestureRecognizer.delegate = self;
    [self configNavigationBar];
    self.barStyle = UIStatusBarStyleLightContent;
//    [self setGesture];
}

- (void)configNavigationBar {
    
    NSDictionary *textAt = @{NSFontAttributeName : CFont(19, 17),NSForegroundColorAttributeName : [UIColor whiteColor]
                             };
    [[UINavigationBar appearance] setTitleTextAttributes:textAt];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationBar setBackgroundImage:[UIImage createImageWithColor:RGB(44, 52, 71)] forBarMetrics:UIBarMetricsDefault];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.navigationBar.translucent = NO;
//    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"nav_btn_back" frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(GoBack)];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.barStyle;
}

- (void)setBarStyle:(UIStatusBarStyle)barStyle {
    _barStyle = barStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setGesture {
    //获取手势系统手势
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    //创建返回手势
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    //添加到当前视图上
    [gestureView addGestureRecognizer:popRecognizer];
    //  获取系统手势的target数组
    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    NSLog(@"%@",_targets);
    // 获取它的Target
    id gestureRecognizerTarget = [_targets firstObject];
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    
    //  通过前面的打印，我们从控制台获取出来它的方法名。
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    //添加到自己新添加的手势上作为监听者
    [popRecognizer addTarget:navigationInteractiveTransition action:handleTransition];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        if (![viewController isKindOfClass:NSClassFromString(@"XDProjectSelectController")]) {
            viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem leftItemWithImageName:@"nav_btn_back" frame:CGRectMake(0, 0, 40, 40) target:self action:@selector(GoBack)];
        }
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

-(void)GoBack{
    
    [self popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
@end

