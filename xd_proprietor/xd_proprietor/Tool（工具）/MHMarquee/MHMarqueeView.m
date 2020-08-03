//
//  MHMarqueeView.m
//  MHMarquee
//
//  Created by mason on 2018/9/3.
//  Copyright © 2018年 mason. All rights reserved.
//

#import "MHMarqueeView.h"

@interface MHMarqueeView ()<UIGestureRecognizerDelegate>

/** <##> */
//@property (strong, nonatomic) UIButton *firstLabel;
///** <##> */
//@property (strong, nonatomic) UIButton *secondLabel;
///** <##> */
//@property (strong, nonatomic) UIButton *thirdLabel;

/** 展示的行数 */
@property (assign, nonatomic) NSInteger lineNumber;
/** label */
@property (strong, nonatomic) NSMutableArray *labelArrays;
/** 行间距 */
@property (assign, nonatomic) CGFloat lineSpace;

@end

@implementation MHMarqueeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.fontSize = 15;
        self.textColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.lineSpace = 5;
        self.lineSpace = (CGRectGetHeight(frame) - self.fontSize) / 2 + 1;
        [self setLineNumber:1];
        [self startAnimation];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame lineNumber:(NSInteger)lineNumber {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.fontSize = 15;
        self.textColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.lineSpace = 5;
        self.lineSpace = (CGRectGetHeight(frame) - self.fontSize * lineNumber) / (lineNumber + 1) + 1;
        [self setLineNumber:lineNumber];
        [self startAnimation];
    }
    return self;
}

- (void)setLineNumber:(NSInteger)lineNumber {
    _lineNumber = lineNumber;
    [self creatMarquee];
}

- (void)setFontSize:(NSInteger)fontSize {
    _fontSize = fontSize;
    [self refreshStyle];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self refreshStyle];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    [self refreshStyle];
}

- (void)setLineSpace:(CGFloat)lineSpace {
    _lineSpace = lineSpace;
    [self refreshStyle];
}

- (void)creatMarquee {
    for (NSInteger i = 0; i < self.lineNumber + 1; i++) {
        UIButton *label = [[UIButton alloc] init];
        [label setUserInteractionEnabled:YES];
        [self.labelArrays addObject:label];
        [self addSubview:label];
        
        [label addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];

        label.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        label.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        label.font = [UIFont systemFontOfSize:self.fontSize];
        [label setTitleColor:self.textColor forState:UIControlStateNormal];
    }
}

- (void)refreshStyle {
    for (NSInteger i = 0; i < self.labelArrays.count; i++) {
        UIButton *label = self.labelArrays[i];
       
        label.font = [UIFont systemFontOfSize:self.fontSize];
        [label setTitleColor:self.textColor forState:UIControlStateNormal];
        label.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        label.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        label.frame = CGRectMake(0, self.lineSpace + (self.fontSize + self.lineSpace) * i, self.frame.size.width, self.fontSize);
    }
}

- (void)clickAction:(UIButton*)sender{
    
}

- (void)startAnimation {
    CGFloat height = self.fontSize;
    CGFloat width = self.frame.size.width;
    
    for (NSInteger i = 0; i < self.labelArrays.count; i++) {
        UIButton *label = self.labelArrays[i];
        label.frame = CGRectMake(0, self.lineSpace + (height + self.lineSpace) * i, width, height);
        NSInteger index = [self beyondIndex:self.currentIndex + i];
        if (index < self.dataSource.count) {
            [label setTitle:self.dataSource[index] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        for (NSInteger i = 0; i < self.labelArrays.count; i++) {
            UIButton *label = self.labelArrays[i];
            label.frame = CGRectMake(0, self.lineSpace - (height + self.lineSpace) + (height + self.lineSpace) * i, width, height);
        }
    } completion:^(BOOL finished) {
        UIButton *tmpLabel = self.labelArrays.firstObject;
        for (NSInteger i = 0; i < self.labelArrays.count; i++) {
            if (i + 1 == self.labelArrays.count) {
                self.labelArrays[i] = tmpLabel;
            } else {
                self.labelArrays[i] = self.labelArrays[i + 1];
            }
        }
        self.currentIndex = [self beyondIndex:self.currentIndex+1];
        [self startAnimation];
    }];
}


- (NSMutableArray *)labelArrays {
    if (!_labelArrays) {
        _labelArrays = [NSMutableArray array];
    }
    return _labelArrays;
}

- (NSInteger)beyondIndex:(NSInteger)index{
    NSInteger nextIndex = index;
    if (nextIndex >= self.dataSource.count) {
        nextIndex = nextIndex - self.dataSource.count;
    }
    return nextIndex;
}

@end































