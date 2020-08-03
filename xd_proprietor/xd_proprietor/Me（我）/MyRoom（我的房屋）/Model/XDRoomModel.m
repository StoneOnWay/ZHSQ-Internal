//
//  Created by cfsc on 2020/3/10.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDRoomModel.h"

@implementation XDRoomModel
MJCodingImplementation
+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"roomId"]) {
        return @"id";
    }
    return nil;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"householdBoList":[XDUserModel class]};
}
@end
