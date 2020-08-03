//
//  XDInfoNewDetailNetController.h
//  XD业主
//
//  Created by zc on 2017/6/30.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDContentInfoModel.h"

@interface XDInfoNewDetailNetController : UIViewController

// 公告模型
@property (nonatomic , strong) XDContentInfoModel *infoModel;

@property (nonatomic, copy) void (^readCountDidUpdate)(void);

@end
