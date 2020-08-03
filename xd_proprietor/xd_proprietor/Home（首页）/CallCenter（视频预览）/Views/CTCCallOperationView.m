//
//  CTCCallOperationView.m
//  CommunityCloud
//
//  Created by shilei on 17/11/22.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "Masonry.h"
#import "CTCCallOperationView.h"

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CTCCallOperationView ()

@property (nonatomic, strong) UILabel *rejectLabel; /**< 呼叫时挂断文字*/

@property (nonatomic, strong) UILabel *answerLabel; /**< 接听文字*/

@property (nonatomic, strong) UILabel *hangUpLabel;    /**< 通话挂断文字*/

@property (nonatomic, strong) UILabel *screenshotLabel; /**< 截图文字*/

@property (nonatomic, strong) UILabel *answeredScreenshotLabel; /**< 截图文字*/
@end

@implementation CTCCallOperationView
#pragma mark - ===============Life Cycle=============
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}
#pragma mark - ===============Init UI   =============
- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
//    [self addSubview:self.screenshotButton];
//    [self addSubview:self.screenshotLabel];
    [self addSubview:self.rejectButton];
    [self addSubview:self.rejectLabel];
    [self addSubview:self.answerButton];
    [self addSubview:self.answerLabel];
//    [self addSubview:self.answeredScreenshotButton];
//    [self addSubview:self.answeredScreenshotLabel];
    [self addSubview:self.hangUpButton];
    [self addSubview:self.hangUpLabel];
    
//    [self.screenshotButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(16.0f);
//        make.centerY.equalTo(self).offset(-11.0f);
//    }];
//
//    [self.screenshotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.screenshotButton);
//        make.top.equalTo(self.screenshotButton.mas_bottom).offset(6.0f);
//    }];
    CGFloat width = kScreenWidth * 0.25 - 37.0f;
    CGFloat widthAnswered = kScreenWidth * 0.5 - 37.0;
    [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(width);;
        make.centerY.equalTo(self).offset(-11.0f);
    }];
    
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.answerButton);
        make.top.equalTo(self.answerButton.mas_bottom).offset(6.0f);
    }];
    
    [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-width);
        make.centerY.equalTo(self.answerButton);
    }];
    
    [self.rejectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rejectButton);
        make.centerY.equalTo(self.answerLabel);
    }];
    
//    [self.answeredScreenshotButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(41.0f);
//        make.centerY.equalTo(self.screenshotButton);
//    }];
//
//    [self.answeredScreenshotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.answeredScreenshotButton);
//        make.centerY.equalTo(self.screenshotLabel);
//    }];
    
    [self.hangUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-widthAnswered);
        make.centerY.equalTo(self.answerButton);
    }];

    [self.hangUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hangUpButton);
        make.centerY.equalTo(self.answerLabel);
    }];
    
}
#pragma mark - ===============Override Method =======
#pragma mark - ===============Net  Working ==========
#pragma mark - ===============Private Actions   =====
-(void)setIsAnswered:(BOOL)isAnswered {
    _isAnswered = isAnswered;
    if (isAnswered) {
//        _screenshotButton.hidden = YES;
//        _screenshotLabel.hidden = YES;
        _answerButton.hidden = YES;
        _answerLabel.hidden = YES;
        _rejectButton.hidden = YES;
        _rejectLabel.hidden = YES;
//        _answeredScreenshotButton.hidden = NO;
//        _answeredScreenshotLabel.hidden = NO;
        _hangUpButton.hidden = NO;
        _hangUpLabel.hidden = NO;
    } else {
//        _screenshotButton.hidden = NO;
//        _screenshotLabel.hidden = NO;
        _answerButton.hidden = NO;
        _answerLabel.hidden = NO;
        _rejectButton.hidden = NO;
        _rejectLabel.hidden = NO;
//        _answeredScreenshotButton.hidden = YES;
//        _answeredScreenshotLabel.hidden = YES;
        _hangUpButton.hidden = YES;
        _hangUpLabel.hidden = YES;
    }
}

#pragma mark - ===============Setter and Getter======
-(UIButton *)screenshotButton {
    if (!_screenshotButton) {
        _screenshotButton = [[UIButton alloc] init];
        _screenshotButton.hidden = NO;
        [_screenshotButton setImage:[UIImage imageNamed:@"btn_screenshot"] forState:UIControlStateNormal];
    }
    return _screenshotButton;
}

-(UILabel *)screenshotLabel {
    if (!_screenshotLabel) {
        _screenshotLabel = [[UILabel alloc] init];
        _screenshotLabel.textColor = HexRGB(0x313131);
        _screenshotLabel.font = [UIFont systemFontOfSize:14.0f];
        _screenshotLabel.text = @"截图";
    }
    return _screenshotLabel;
}
-(UIButton *)answerButton {
    if (!_answerButton) {
        _answerButton = [[UIButton alloc] init];
        [_answerButton setImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
    }
    return _answerButton;
}

-(UILabel *)answerLabel {
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.textColor = HexRGB(0x313131);
        _answerLabel.font = [UIFont systemFontOfSize:14.0f];
        _answerLabel.text = @"接听";
    }
    return _answerLabel;
}
-(UIButton *)rejectButton {
    if (!_rejectButton) {
        _rejectButton = [[UIButton alloc] init];
        [_rejectButton setImage:[UIImage imageNamed:@"btn_hangup"] forState:UIControlStateNormal];
    }
    return _rejectButton;
}

-(UILabel *)rejectLabel {
    if (!_rejectLabel) {
        _rejectLabel = [[UILabel alloc] init];
        _rejectLabel.textColor = HexRGB(0x313131);
        _rejectLabel.font = [UIFont systemFontOfSize:14.0f];
        _rejectLabel.text = @"挂断";
    }
    return _rejectLabel;
}
-(UIButton *)answeredScreenshotButton {
    if (!_answeredScreenshotButton) {
        _answeredScreenshotButton = [[UIButton alloc] init];
        [_answeredScreenshotButton setImage:[UIImage imageNamed:@"btn_screenshot"] forState:UIControlStateNormal];
        _answeredScreenshotButton.hidden = YES;
    }
    return _answeredScreenshotButton;
}

-(UILabel *)answeredScreenshotLabel {
    if (!_answeredScreenshotLabel) {
        _answeredScreenshotLabel = [[UILabel alloc] init];
        _answeredScreenshotLabel.textColor = HexRGB(0x313131);
        _answeredScreenshotLabel.font = [UIFont systemFontOfSize:14.0f];
        _answeredScreenshotLabel.text = @"截图";
        _answeredScreenshotLabel.hidden = YES;
    }
    return _answeredScreenshotLabel;
}

-(UIButton *)hangUpButton {
    if (!_hangUpButton) {
        _hangUpButton = [[UIButton alloc] init];
        [_hangUpButton setImage:[UIImage imageNamed:@"btn_hangup"] forState:UIControlStateNormal];
        _hangUpButton.hidden = YES;
    }
    return _hangUpButton;
}

-(UILabel *)hangUpLabel {
    if (!_hangUpLabel) {
        _hangUpLabel = [[UILabel alloc] init];
        _hangUpLabel.textColor = HexRGB(0x313131);
        _hangUpLabel.font = [UIFont systemFontOfSize:14.0f];
        _hangUpLabel.text = @"挂断";
        _hangUpLabel.hidden = YES;
    }
    return _hangUpLabel;
}

@end
