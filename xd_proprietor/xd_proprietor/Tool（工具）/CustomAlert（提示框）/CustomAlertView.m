//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by lanshang on 16/6/6.
//  Copyright © 2016年 luckyLin. All rights reserved.
//

#import "CustomAlertView.h"
#define ALERTVIEWWIDTH  kScaleFrom_iPhone5_Desgin(240)
#define margin  kScaleFrom_iPhone5_Desgin(10)

@interface CustomAlertView()

/** <##> */
@property (copy, nonatomic) clickBlock clickBlock;


@end

@implementation CustomAlertView

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andDetail:(NSString *)detail andBody:(NSString *)body andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle andIsOneBtn:(BOOL)isOneBtn {
    return [self initWithFrame:frame WithTitle:title andDetail:detail andBody:body andCancelTitle:cancelTitel andOtherTitle:otherTitle andIsOneBtn:isOneBtn clickBlock:nil];
}

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andDetail:(NSString *)detail andBody:(NSString *)body andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle andIsOneBtn:(BOOL)isOneBtn clickBlock:(clickBlock)clickBlock
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        self.clickBlock = clickBlock;
        [self createUIWithTitle:title andDetail:detail andBody:body andCancelTitle:cancelTitel andOtherTitle:otherTitle andIsOneBtn:isOneBtn];
    }
    return self;
}

-(void)createUIWithTitle:(NSString *)title andDetail:(NSString *)detail andBody:(NSString *)body andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle andIsOneBtn:(BOOL)isOneBtn
{
    self.backGroundView = [[UIView alloc]init];
    self.backGroundView.center = self.center;
    self.backGroundView.backgroundColor = [UIColor colorWithRed:225 green:225 blue:225 alpha:1];
    self.backGroundView.layer.masksToBounds = YES;
    self.backGroundView.layer.cornerRadius = 15;
    [self addSubview:self.backGroundView];
    
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = RGB(79, 79, 79);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = title;
    CGFloat titleHeight = [self getHeightWithTitle:title andFont:CFont(20, 18)];
    self.titleLabel.font = CFont(20, 18);
    self.titleLabel.frame = CGRectMake(15, margin*2, ALERTVIEWWIDTH-20*2, titleHeight);
    self.titleLabel.numberOfLines = 0;
    [self.backGroundView addSubview:self.titleLabel];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.backGroundView addSubview:scrollView];
    
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.textColor = RGB(155, 155, 155);
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = detail;
    CGFloat detailHeight = [self getHeightWithTitle:detail andFont:CFont(17, 15)];
    CGFloat scrollHeight = detailHeight;
    if (detailHeight > kScaleFrom_iPhone5_Desgin(350)) {
        detailHeight = kScaleFrom_iPhone5_Desgin(350);
    }
    self.detailLabel.font = CFont(17, 15);
    self.detailLabel.frame = CGRectMake(0,0, ALERTVIEWWIDTH-20*2, scrollHeight);
    self.detailLabel.tag = 306;
    self.detailLabel.userInteractionEnabled = YES;
    [scrollView addSubview:self.detailLabel];
    scrollView.frame = CGRectMake(20,margin+self.titleLabel.y + titleHeight, ALERTVIEWWIDTH-20*2, detailHeight);
    scrollView.contentSize = CGSizeMake(ALERTVIEWWIDTH-20*2,scrollHeight);
    
    self.horLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,scrollView.y + detailHeight + margin*2 , ALERTVIEWWIDTH, 1)];
    self.horLabel.backgroundColor = [UIColor lightGrayColor];
    [self.backGroundView addSubview:self.horLabel];
    
    
    if (isOneBtn) {
        
        self.otherButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.otherButton.frame = CGRectMake(0, self.horLabel.frame.origin.y+margin/2,ALERTVIEWWIDTH , margin*3);
        [self.otherButton setTitle:otherTitle forState:UIControlStateNormal];
        self.otherButton.titleLabel.font = CFont(18, 16);
        [self.otherButton setTitleColor:BianKuang forState:UIControlStateNormal];
        self.otherButton.tag = 309;
        [self.otherButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:self.otherButton];
        
        
    }else {
        
        self.verLabel = [[UILabel alloc]init];
        self.verLabel.frame = CGRectMake(ALERTVIEWWIDTH/2, self.horLabel.frame.origin.y + 1 + margin/2, 1, margin*3);
        self.verLabel.backgroundColor = [UIColor lightGrayColor];
        [self.backGroundView addSubview:self.verLabel];
        
        
        
        self.canleButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.canleButton.frame = CGRectMake(0, self.horLabel.frame.origin.y + margin/2, ALERTVIEWWIDTH/2, margin*3);
        [self.canleButton setTitle:cancelTitel forState:UIControlStateNormal];
        self.canleButton.titleLabel.font = CFont(18, 16);
        [self.canleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.canleButton.tag = 308;
        [self.canleButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview: self.canleButton];
        
        self.otherButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.otherButton.frame = CGRectMake(ALERTVIEWWIDTH/2, self.horLabel.frame.origin.y + margin/2, ALERTVIEWWIDTH/2, margin*3);
        [self.otherButton setTitle:otherTitle forState:UIControlStateNormal];
        self.otherButton.titleLabel.font = CFont(18, 16);
        [self.otherButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.otherButton.tag = 309;
        [self.otherButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:self.otherButton];
        
        
        
        
    }
    
    
    self.backGroundView.bounds = CGRectMake(0, 0, ALERTVIEWWIDTH,kScaleFrom_iPhone5_Desgin(90)+ titleHeight + detailHeight );
    //用不上暂时
    //    UITapGestureRecognizer *tapDetailLab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDoSomething:)];
    //    [self.detailLabel addGestureRecognizer:tapDetailLab];
    //    UITapGestureRecognizer *tapBodyLab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDoSomething:)];
    //    [self.bodyLabel addGestureRecognizer:tapBodyLab];
    
    [self shakeToShow:self.backGroundView];
    
}

- (void)setIsLeft:(BOOL)isLeft {
    _isLeft = isLeft;
    
    if (isLeft) {
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
    }else {
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    
}
//动态计算高度
-(CGFloat)getHeightWithTitle:(NSString *)title andFont:(UIFont *)fontsize
{
    CGFloat height = [title boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontsize} context:nil].size.height;
    return height;
}

//显示提示框的动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

//点击(取消,确定)按钮调用方法
-(void)clickToUseDelegate:(UIButton *)button
{
    if (self.clickBlock) {
        self.clickBlock(button);
    }
    
    if ([self.delegate respondsToSelector:@selector(clickButtonWithTag:)])
    {
        [self.delegate clickButtonWithTag:button];
    }
    if (!self.isHide) {
        [self removeFromSuperview];
    }
    
}

-(void)toDoSomething:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(clickLabelWithTag:)])
    {
        [self.delegate clickLabelWithTag:tap.self.view];
    }
    
    [self removeFromSuperview];
}



@end

