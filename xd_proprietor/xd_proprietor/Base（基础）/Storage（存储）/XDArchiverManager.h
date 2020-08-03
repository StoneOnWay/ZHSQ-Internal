//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDArchiverManager : NSObject
// 存储本地登录过得用户信息
+ (void)saveLoginInfo:(XDLoginInfoModel *)model;
// 读取登录用户信息
+ (XDLoginInfoModel *)loginInfo;
@end

NS_ASSUME_NONNULL_END
