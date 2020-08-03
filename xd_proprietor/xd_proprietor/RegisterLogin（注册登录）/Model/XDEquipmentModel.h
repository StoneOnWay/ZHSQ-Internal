//
//  Created by cfsc on 2020/3/17.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDEquipmentModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *deviceSerial;
@property (nonatomic, copy) NSString *validateCode;
@property (nonatomic, copy) NSString *devicePlatformId;
@property (nonatomic, copy) NSString *deviceName;
// 设备状态 0：离线 1：在线
@property (nonatomic, copy) NSString *deviceStatus;
@end

NS_ASSUME_NONNULL_END
