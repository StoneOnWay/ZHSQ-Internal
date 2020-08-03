//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDUserModel.h"
#import "XDRoomModel.h"

@implementation XDUserModel
MJCodingImplementation
+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"userID"]) {
        return @"id";
    }
    return nil;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"roomList":[XDRoomModel class],
             @"equipmentInfoBoList":[XDEquipmentModel class]
             };
}

@end
