//
//  Created by cfsc on 2020/3/18.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDVisitorModel : NSObject
// 邀请人姓名
@property (nonatomic, copy) NSString *visitorName;
// 生效时间
@property (nonatomic, copy) NSString *effectTime;
// 失效时间
@property (nonatomic, copy) NSString *expireTime;
// 次数
@property (nonatomic, assign) int openTimes;
// 二维码链接
@property (nonatomic, copy) NSString *qrcodeUrl;
// 是否有效
@property (copy , nonatomic) NSString *iseffective;
@end

NS_ASSUME_NONNULL_END
