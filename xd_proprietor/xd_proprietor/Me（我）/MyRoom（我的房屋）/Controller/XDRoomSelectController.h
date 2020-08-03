//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDRoomSelectController : UIViewController
// 单元ID，用于请求房屋数据
@property (nonatomic, copy) NSString *unitID;
// 单元名
@property (nonatomic, copy) NSString *unitName;
@end

NS_ASSUME_NONNULL_END
