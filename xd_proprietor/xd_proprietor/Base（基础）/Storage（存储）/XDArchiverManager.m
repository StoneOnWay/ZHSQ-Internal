//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDArchiverManager.h"
#import "XDLoginInfoModel.h"

#define KLoginInfoArrayPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"loginInfoArray.plist"]

@implementation XDArchiverManager
// 存储本地登录过得用户信息
+ (void)saveLoginInfo:(XDLoginInfoModel *)model {
    // 归档
    [NSKeyedArchiver archiveRootObject:model toFile:KLoginInfoArrayPath];
}

// 读取登录用户信息
+ (XDLoginInfoModel *)loginInfo {
    // 读取
    XDLoginInfoModel *loginInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:KLoginInfoArrayPath];
    return loginInfo;
}
@end
