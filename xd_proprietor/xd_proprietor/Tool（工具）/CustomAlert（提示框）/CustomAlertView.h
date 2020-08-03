//
//  CustomAlertView.h
//  CustomAlertView
//
//  Created by lanshang on 16/6/6.
//  Copyright © 2016年 luckyLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegate <NSObject>

@optional

-(void)clickLabelWithTag:(UIView *)label;

-(void)clickButtonWithTag:(UIButton *)button;

@end

typedef void(^clickBlock) (UIButton *btn);


@interface CustomAlertView : UIView

@property (nonatomic,strong)UIView *backGroundView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UILabel *bodyLabel;
@property (nonatomic,strong)UIButton *canleButton;
@property (nonatomic,strong)UIButton *otherButton;
@property (nonatomic,strong)UILabel *horLabel;
@property (nonatomic,strong)UILabel *verLabel;

@property (nonatomic,assign)BOOL isOneBtn;
//是否隐藏
@property (nonatomic,assign)BOOL isHide;
//是否详情label是否靠左显示
@property (nonatomic,assign)BOOL isLeft;

@property (nonatomic,assign)id<CustomAlertViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andDetail:(NSString *)detail andBody:(NSString *)body andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle andIsOneBtn:(BOOL)isOneBtn;

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andDetail:(NSString *)detail andBody:(NSString *)body andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle andIsOneBtn:(BOOL)isOneBtn clickBlock:(clickBlock)clickBlock;

@end
