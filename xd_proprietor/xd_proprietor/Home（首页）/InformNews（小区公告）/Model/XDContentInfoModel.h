//
//  Created by cfsc on 2020/3/11.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDAttachmentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDContentInfoModel : NSObject
// 内容ID
@property (nonatomic, copy) NSString *contentID;
// 详情URL
@property (nonatomic, copy) NSString *detailUrl;
// 标题
@property (nonatomic, copy) NSString *title;
// 副标题
@property (nonatomic, copy) NSString *summary;
// 发布时间
@property (nonatomic, copy) NSString *publishTime;
// 发布人
@property (nonatomic, copy) NSString *publisher;
// 浏览数
@property (nonatomic, copy) NSString *browseNum;
// 点赞数
@property (nonatomic, copy) NSString *praiseNum;
// 封面图片
@property (nonatomic, copy) NSString *coverUrl;
// 是否点赞
@property (nonatomic, copy) NSString *isThumbup;
// 附件
@property (nonatomic, copy) NSArray <XDAttachmentModel*>*attachments;
@end

NS_ASSUME_NONNULL_END
