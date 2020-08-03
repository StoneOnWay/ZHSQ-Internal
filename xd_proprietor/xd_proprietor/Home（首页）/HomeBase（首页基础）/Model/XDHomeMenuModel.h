//
//  XDHomeMenuModel.h
//  xd_proprietor
//
//  Created by mason on 2018/9/3.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XDVCType) {
    XDVCTypeAlloc,
    XDVCTypeStoryboard,
    XDVCTypeXib,
    XDVCTypeJxbWeb
};

@interface XDHomeMenuModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) id value;
@property (assign, nonatomic) XDVCType vcType;
@property (strong, nonatomic) NSString *viewControllerStr;
@property (strong, nonatomic) NSString *vcSubType;
@property (nonatomic, copy) NSString *jxbUrl;

@property (copy, nonatomic) NSString *iconUrl;

@end

