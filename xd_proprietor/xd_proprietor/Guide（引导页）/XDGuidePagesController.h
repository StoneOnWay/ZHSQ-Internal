//
//  Created by cfsc on 2020/2/2.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CALayer+Transition.h"

@protocol XDGuidePagesControllerDelegate <NSObject>

- (void)clickEnter;

@end

@interface XDGuidePagesController : UIViewController

@property (nonatomic, strong) UIButton *btnEnter;
// 初始化引导页
- (void)guidePageControllerWithImages:(NSArray *)images;
+ (BOOL)shouldShow;
@property (nonatomic, assign) id<XDGuidePagesControllerDelegate> delegate;

@end
