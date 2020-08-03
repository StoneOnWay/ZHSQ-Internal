//
//  Created by cfsc on 2020/7/24.
//  Copyright © 2020 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDCommunityPermissionModel : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *deviceStatus;
@property (nonatomic, copy) NSString *deviceStatusText;
@property (nonatomic, copy) NSString *distributeTime;
@property (nonatomic, copy) NSString *personStatus;
@property (nonatomic, copy) NSString *personStatusText;
@property (nonatomic, copy) NSString *cardStatus;
@property (nonatomic, copy) NSString *cardStatusText;
@property (nonatomic, copy) NSString *faceStatus;
@property (nonatomic, copy) NSString *faceStatusText;

@end

NS_ASSUME_NONNULL_END
