//
//  Created by cfsc on 2020/3/11.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDContentInfoModel.h"

@implementation XDContentInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"contentID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"attachments":[XDAttachmentModel class]};
}
@end
