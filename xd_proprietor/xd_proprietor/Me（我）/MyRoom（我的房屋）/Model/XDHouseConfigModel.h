//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDHouseConfigModel : NSObject

// 级别
@property (nonatomic, assign) NSInteger level;
// 名称
@property (nonatomic, copy) NSString *title;
// key
@property (nonatomic, copy) NSString *key;
// children
@property (nonatomic, copy) NSArray <XDHouseConfigModel *>*children;

@end

NS_ASSUME_NONNULL_END
