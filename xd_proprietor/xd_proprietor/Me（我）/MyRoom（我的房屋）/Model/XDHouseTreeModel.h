//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDHouseConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDHouseTreeModel : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSArray <XDHouseConfigModel *>*result;
@end

NS_ASSUME_NONNULL_END
