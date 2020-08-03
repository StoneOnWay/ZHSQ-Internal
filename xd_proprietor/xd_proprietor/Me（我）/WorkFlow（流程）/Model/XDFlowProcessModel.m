//
//  Created by cfsc on 2020/3/19.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDFlowProcessModel.h"
#import "XDResourceModel.h"
#import "XDFlowFormModel.h"
#import "XDFlowOperationModel.h"

@implementation XDFlowProcessModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"resourceValue" : [XDResourceModel class],
             @"operationInfos" : [XDFlowOperationModel class],
             @"formContent" : [XDFlowFormModel class]
             };
}

@end
