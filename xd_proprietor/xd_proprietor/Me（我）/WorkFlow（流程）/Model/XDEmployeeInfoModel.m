//
//  Created by cfsc on 2020/3/30.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDEmployeeInfoModel.h"

@implementation XDEmployeeInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"employeeId":@"id"};
}
@end
