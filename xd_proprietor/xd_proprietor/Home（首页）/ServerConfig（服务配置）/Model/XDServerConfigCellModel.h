//
//  Created by cfsc on 2020/7/13.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,ServeButtonStates) {
    ServeAdd = 0,
    ServeSelected
};


@interface XDServerConfigCellModel : NSObject

@property (nonatomic, strong) UIColor *backGroundColor;
@property (nonatomic, assign) ServeButtonStates state;
@property (nonatomic, assign) BOOL isSectionOne;
@property (nonatomic, assign) BOOL isNewAdd;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *programId;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *routeAddress;
// 跳转类型：内外部跳转
@property (nonatomic, copy) NSString *type;

@end
