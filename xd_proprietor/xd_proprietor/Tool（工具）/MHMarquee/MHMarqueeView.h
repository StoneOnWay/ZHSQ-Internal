//
//  MHMarqueeView.h
//  MHMarquee
//
//  Created by mason on 2018/9/3.
//  Copyright © 2018年 mason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MHMarqueeScrollDirection) {
    MHMarqueeScrollDirectionUp,
    MHMarqueeScrollDirectionDown,
    MHMarqueeScrollDirectionLeft,
    MHMarqueeScrollDirectionRight
};

@interface MHMarqueeView : UIView

- (instancetype)initWithFrame:(CGRect)frame lineNumber:(NSInteger)lineNumber;

/** 文字大小 */
@property (assign, nonatomic) NSInteger fontSize;
/** 文字颜色 */
@property (strong, nonatomic) UIColor *textColor;
/** 对齐方式 */
@property (assign, nonatomic) NSTextAlignment textAlignment;
/** 滚动方向<##> */
@property (assign, nonatomic) MHMarqueeScrollDirection scrollDirection;
/** 数据源 */
@property (strong, nonatomic) NSArray *dataSource;
/** 当前下标 */
@property (assign, nonatomic) NSInteger currentIndex;

@end








