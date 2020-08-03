//
//  Created by cfsc on 2020/5/22.
//  Copyright © 2020 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTCPlayerView.h"
#import "CloudVoiceTalkParamsModel.h"
#import "CloudOpenSDK.h"

typedef void(^InitSdkCompletion)(BOOL success);

NS_ASSUME_NONNULL_BEGIN

@interface XDCallCenterBusiness : NSObject

@property (nonatomic, strong) CloudVoiceTalkParamsModel *talkModel;

+ (instancetype)sharedInstance;

/// 开始视频预览
/// @param playView 播放的view容器
- (void)startVideoPlay:(CTCPlayerView *)playView;

/// 结束预览
- (BOOL)stopRealPlay;

/// 初始化海康Sdk
/// @param completion 回调
- (void)initialHikSdk:(InitSdkCompletion)completion;

@end

NS_ASSUME_NONNULL_END
