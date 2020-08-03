//
//  Created by cfsc on 2020/3/19.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDFlowDetailModel.h"
#import "XDResourceModel.h"

@implementation XDFlowDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"processes" : [XDFlowProcessModel class],
             @"problemResourceValue" : [XDResourceModel class]
             };
}

@end
