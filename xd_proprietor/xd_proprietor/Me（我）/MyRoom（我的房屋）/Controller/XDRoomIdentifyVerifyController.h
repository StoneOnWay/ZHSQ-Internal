//
//  Created by cfsc on 2020/3/14.
//  Copyright © 2020年 zc. All rights reserved.
//  提交房屋审核

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDRoomIdentifyVerifyController : UIViewController
@property (nonatomic, strong) XDRoomModel *roomModel;
// 房间身份类型
@property (nonatomic, copy) NSString *roomIdentifyType;
@end

NS_ASSUME_NONNULL_END
