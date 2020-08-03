//
//  XDFlowOperationBtnView.h
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XDFlowOperationBtnType) {
    XDFlowOperationBtnTypeSingle,
    XDFlowOperationBtnTypeDouble
};

typedef NS_ENUM(NSInteger, XDClickType) {
    XDClickTypeCenter,
    XDClickTypeLeft,
    XDClickTypeRight
};

typedef void(^clickOperationBlock) (XDClickType clickType);

@interface XDFlowOperationBtnView : UIView

@property (assign, nonatomic) XDFlowOperationBtnType operationBtnType;

@property (copy, nonatomic) NSString *singleBtnTitle;
@property (copy, nonatomic) NSString *leftBtnTitle;
@property (copy, nonatomic) NSString *rightBtnTitle;
@property (copy, nonatomic) clickOperationBlock clickOperationBlock;


@end
