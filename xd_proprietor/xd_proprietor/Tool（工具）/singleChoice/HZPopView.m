//
//  HZPopView.m
//  Pods
//
//  Created by mason on 2017/8/1.
//
//

#import "HZPopView.h"

@interface HZPopView ()

/** 从控制器传入来的View，用来显示在 containerView 身上 */
@property (nonatomic, weak) UIView *contentContainView;
/** 最底部的遮盖：屏蔽除了菜单以外控件的事件 */
@property (nonatomic, weak) UIButton *cover;

@end

@implementation HZPopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
        cover.backgroundColor = RGBA(0, 0, 0, 0.3);
        [cover addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cover];
        self.cover = cover;
        
        UIView *contentContainView = [[UIView alloc] init];
        contentContainView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentContainView];
        self.contentContainView = contentContainView;
    }
    return self;
}

- (void)layoutSubviews {
    self.cover.frame = self.bounds;
}

- (void)popViewWithContenView:(UIView *)contenView inRect:(CGRect)rect inContainer:(UIView *)container{
    // 添加菜单父View身上
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSArray *windowSubviews = window.subviews;
    for (UIView *view in windowSubviews) {
        if ([view isKindOfClass:[HZPopView class]]) {
            return;
        }
    }
    
    if (container) {
        self.frame = container.bounds;
        [container addSubview:self];
    } else {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [window addSubview:self];
    }
    [self.contentContainView addSubview:contenView];
    [self.contentContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(rect.size);
    }];
    [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentContainView).with.insets(UIEdgeInsetsZero);
    }];
    
    self.contentContainView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentContainView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

- (void) diss {
    self.contentContainView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentContainView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
