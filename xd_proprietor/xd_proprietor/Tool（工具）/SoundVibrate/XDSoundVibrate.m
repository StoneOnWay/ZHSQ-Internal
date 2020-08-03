//
//  XDSoundVibrate.m
//  xd_proprietor
//
//  Created by stone on 24/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDSoundVibrate.h"
#import <AudioToolbox/AudioToolbox.h>

void soundCompleteCallback(SystemSoundID sound,void * clientData) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(sound);
}

@implementation XDSoundVibrate {
    SystemSoundID soundID;
}

- (void)playVibration {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)stopVibration {
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
}

- (void)playAlertSoundWithSourcePath:(NSString *)path isCyclic:(BOOL)isCyclic {
    usleep(1000);
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:path ofType:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:soundFile], &soundID);
    
    AudioServicesPlaySystemSound(soundID);
    if (isCyclic) {
        AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    }
}

- (void)stopAlertSound {
    AudioServicesDisposeSystemSoundID(soundID);
    AudioServicesRemoveSystemSoundCompletion(soundID);
}

+ (instancetype)shareXDSoundVibrate {
    static id _instance;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

@end
