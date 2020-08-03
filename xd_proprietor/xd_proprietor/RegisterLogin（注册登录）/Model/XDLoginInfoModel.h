//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDLoginTokenModel.h"
#import "XDUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDLoginInfoModel : NSObject <NSCoding>
@property (nonatomic, strong) XDLoginTokenModel *tokenModel;
@property (nonatomic, strong) XDUserModel *userModel;
@end

NS_ASSUME_NONNULL_END
