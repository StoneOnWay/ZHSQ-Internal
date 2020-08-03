//
//  CTCCallOperationView.h
//  CommunityCloud
//
//  Created by shilei on 17/11/22.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCCallOperationView : UIView
@property (nonatomic, assign) BOOL isAnswered;

@property (nonatomic, strong) UIButton *rejectButton; /**< 呼叫时挂断按钮*/

@property (nonatomic, strong) UIButton *answerButton; /**< 接听按钮*/

@property (nonatomic, strong) UIButton *hangUpButton;  /**< 通话挂断按钮*/

@property (nonatomic, strong) UIButton *screenshotButton; /**< 截图按钮*/

@property (nonatomic, strong) UIButton *answeredScreenshotButton; /**< 截图按钮*/

@end
