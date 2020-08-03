//
//  CloudVoiceTalkParamsModel.h
//  CloudOpenSDK
//
//  Created by huyechao on 2019/6/20.
//  Copyright © 2019 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CloudVoiceTalkParamsModel : NSObject
@property (nonatomic, copy) NSString *callId; //呼叫标识，用于区分不同呼叫信息,目前没用到,传空 长度32
@property (nonatomic, copy) NSString *deviceSerial; // 呼叫设备序列号 长度32
@property (nonatomic, assign) NSInteger channelNo; // 通道号
@property (nonatomic, copy) NSString *verifyCode; // 设备验证码，加密的设备需要传验证码
@property (nonatomic, copy) NSString *room; // 房间号 长度2
@property (nonatomic, copy) NSString *periodNumber; // 期号 长度2
@property (nonatomic, copy) NSString *buildingNumber; // 楼号 长度2
@property (nonatomic, copy) NSString *unitNumber; // 单元号 长度2
@property (nonatomic, copy) NSString *floorNumber; // 层号 长度2
@property (nonatomic, copy) NSString *devIndex; // 设备序号 长度2
@property (nonatomic, copy) NSString *unitType; // 类型: outdoor门口机，wall围墙机 长度16

@end

NS_ASSUME_NONNULL_END
