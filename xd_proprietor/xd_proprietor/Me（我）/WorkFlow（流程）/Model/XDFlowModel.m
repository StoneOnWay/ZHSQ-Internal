//
//  Created by cfsc on 2020/3/19.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDFlowModel.h"

@implementation XDFlowModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"flowId":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"problemResourceValue" : [XDResourceModel class]};
}

@end
