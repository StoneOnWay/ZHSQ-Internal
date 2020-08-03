//
//  XDSoundVibrate.h
//  xd_proprietor
//
//  Created by stone on 24/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDSoundVibrate : NSObject

//@property (nonatomic,assign) SystemSoundID soundId;

+ (instancetype)shareXDSoundVibrate;

/**
 播放caf文件

 @param path 文件名
 @param isCycli 是否循环
 */
- (void)playAlertSoundWithSourcePath:(NSString *)path isCyclic:(BOOL)isCycli;

/**
 停止播放
 */
- (void)stopAlertSound;

@end

NS_ASSUME_NONNULL_END
