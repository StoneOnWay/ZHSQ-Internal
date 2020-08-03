//
//  XDSettingsConfigModel.h
//  xd_proprietor
//
//  Created by stone on 15/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SettingType) {
    SettingTypeDefault,
    SettingTypeExit
};

NS_ASSUME_NONNULL_BEGIN

@interface XDSettingsConfigModel : NSObject
// 标题
@property (nonatomic, copy) NSString *title;
// 副标题
@property (nonatomic, copy) NSString *subTitle;
// 是否有下级页面
@property (nonatomic, assign) BOOL hasArrow;
// 设置类型
@property (nonatomic, assign) SettingType type;
@end

NS_ASSUME_NONNULL_END
