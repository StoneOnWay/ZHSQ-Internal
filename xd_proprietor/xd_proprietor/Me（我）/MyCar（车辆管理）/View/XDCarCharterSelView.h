//
//  XDCarCharterSelView.h
//  xd_proprietor
//
//  Created by cfsc on 2019/6/17.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CarCharterType) {
    CarCharterTypeMonthOne = 1001,
    CarCharterTypeMonthThree = 1003,
    CarCharterTypeMonthSix= 1006
};

NS_ASSUME_NONNULL_BEGIN

@interface XDCarCharterSelView : UIView
@property (nonatomic, copy) void (^charterViewClick)(CarCharterType type);
+ (XDCarCharterSelView *)createCarCharterSelView;
@end

NS_ASSUME_NONNULL_END
