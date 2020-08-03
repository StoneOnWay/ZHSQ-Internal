//
//  XDPersonalConfigModel.h
//  xd_proprietor
//
//  Created by stone on 14/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDPersonalConfigModel : NSObject
// 标题
@property (nonatomic, copy) NSString *title;
// 副标题
@property (nonatomic, copy) NSString *subTitle;
// 是否图片副标题
@property (nonatomic, assign) BOOL isImage;
// 是否有下级页面
@property (nonatomic, assign) BOOL hasArrow;
// 图片url
@property (nonatomic, copy) NSString *headUrl;
// 本地图片
@property (nonatomic, strong) UIImage *headImage;
@end

NS_ASSUME_NONNULL_END
