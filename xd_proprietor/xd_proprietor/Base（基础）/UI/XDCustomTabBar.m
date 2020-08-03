//
//  Created by cfsc on 2020/4/21.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDCustomTabBar.h"

#define AddButtonMargin 20

@interface XDCustomTabBar()

// 圆形背景
@property (nonatomic,weak) UIButton *circleBtn;
// 指向中间“+”按钮
@property (nonatomic,weak) UIButton *addButton;
// 指向“添加”标签
@property (nonatomic,weak) UILabel *addLabel;

@end

@implementation XDCustomTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // 设置默认背景图片
        [circleBtn setBackgroundImage:[UIImage imageWithColor:RGB(236, 236, 236)] forState:UIControlStateNormal];
        // 设置按下时背景图片
        [circleBtn setBackgroundImage:[UIImage imageWithColor:RGB(236, 236, 236)] forState:UIControlStateHighlighted];
        // 将按钮添加到TabBar
        [self addSubview:circleBtn];
        self.circleBtn = circleBtn;
        // 创建中间“+”按钮
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"home_openKey"] forState:UIControlStateNormal];
        // 添加响应事件
        [addBtn addTarget:self action:@selector(addBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        // 将按钮添加到TabBar
        [self addSubview:addBtn];
        self.addButton = addBtn;
    }
    return self;
}

// 响应中间“+”按钮点击事件
- (void)addBtnDidClick {
    if ([self.myTabBarDelegate respondsToSelector:@selector(openButtonClick:)]) {
        [self.myTabBarDelegate openButtonClick:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = self.items.count;
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = w / (count + 1);
    CGFloat btnH = self.bounds.size.height;
    
    NSInteger i = 0;
    for (UIView *tabBarButton in self.subviews) {
        // 判断下是否是UITabBarButton
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton" )]) {
            if (i == count / 2) {
                i = count / 2 + 1;
            }
            btnX = i * btnW;
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i++;
        }
    }
    // 设置添加按钮的位置
    self.circleBtn.size = CGSizeMake(70, 70);
    self.circleBtn.center = CGPointMake(w * 0.5, h * 0.2);
    self.circleBtn.layer.cornerRadius = 35;
    self.circleBtn.layer.masksToBounds = YES;
    self.addButton.size = CGSizeMake(45, 45);
    self.addButton.center = CGPointMake(w * 0.5, h * 0.2);
    
    
    // 去掉TabBar上部的横线
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
            UIImageView *line = (UIImageView *)view;
            line.hidden = YES;
        }
    }

    // 创建并设置“+”按钮下方的文本为
    UILabel *addLbl = [[UILabel alloc] init];
    addLbl.text = @"一键开门";
    addLbl.font = [UIFont systemFontOfSize:10];
    addLbl.textColor = [UIColor grayColor];
    [addLbl sizeToFit];
    // 设置“添加”label的位置
    addLbl.centerX = self.addButton.centerX;
    addLbl.centerY = CGRectGetMaxY(self.addButton.frame) + 10;
    [self addSubview:addLbl];
    self.addLabel = addLbl;
}

//重写hitTest方法，去监听"+"按钮和“添加”标签的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //这一个判断是关键，不判断的话push到其他页面，点击“+”按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有TabBar的，那么肯定是在根控制器页面
    //在根控制器页面，那么我们就需要判断手指点击的位置是否在“+”按钮或“添加”标签上
    //是的话让“+”按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO)
    {
        
        //将当前TabBar的触摸点转换坐标系，转换到“+”按钮的身上，生成一个新的点
        CGPoint newA = [self convertPoint:point toView:self.addButton];
        //将当前TabBar的触摸点转换坐标系，转换到“添加”标签的身上，生成一个新的点
        CGPoint newL = [self convertPoint:point toView:self.addLabel];
        
        //判断如果这个新的点是在“+”按钮身上，那么处理点击事件最合适的view就是“+”按钮
        if ( [self.addButton pointInside:newA withEvent:event])
        {
            return self.addButton;
        }
        //判断如果这个新的点是在“添加”标签身上，那么也让“+”按钮处理事件
        else if([self.addLabel pointInside:newL withEvent:event])
        {
            return self.addButton;
        }
        else
        {//如果点不在“+”按钮身上，直接让系统处理就可以了
            
            return [super hitTest:point withEvent:event];
        }
    }
    else
    {
        //TabBar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
