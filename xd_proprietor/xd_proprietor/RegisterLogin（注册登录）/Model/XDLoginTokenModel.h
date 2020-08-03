//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDLoginTokenModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *token_type;
@property (nonatomic, copy) NSString *access_token;
@end

NS_ASSUME_NONNULL_END
