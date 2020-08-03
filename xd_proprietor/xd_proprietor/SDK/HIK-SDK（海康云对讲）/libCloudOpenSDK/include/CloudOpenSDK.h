//
//  CloudOpenSDK.h
//  CloudOpenSDK
//
//  Created by huyechao on 2019/6/10.
//  Copyright © 2019 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EZConstants.h"
#import "EZPlayer.h"

OBJC_EXTERN NSString * const kSDKTokenExpireNotification;           // token失效通知

typedef NS_ENUM(NSInteger, CloudDeviceCallStatus) {
    CloudDeviceCallStatusNoCall     = 1,            //无呼叫
    CloudDeviceCallStatusCalling    = 2,            //呼叫中
    CloudDeviceCallStatusAnswering  = 3,            //通话中
};

typedef NS_ENUM(NSInteger, CloudVideoPTZCommand) {
    CloudVideoPTZCommandUp      = 0,            //上
    CloudVideoPTZCommandDown    = 1,            //下
    CloudVideoPTZCommandLeft    = 2,            //左
    CloudVideoPTZCommandRight   = 3,            //右
    CloudVideoPTZCommandZoomOut = 8,            //放大
    CloudVideoPTZCommandZoomIn  = 9,            //缩小
};

/**
 *  设备ptz动作命令
 */
typedef NS_ENUM(NSInteger, CloudVideoPTZAction) {
    CloudVideoPTZActionStart = 1,  //ptz开始
    CloudVideoPTZActionStop  = 2   //ptz停止
};

@class EZDeviceRecordFile,EZCloudRecordFile,EZDeviceInfo,CloudVoiceTalkParamsModel;
@interface CloudOpenSDK : NSObject

#pragma mark - 版本管理
/**
 *
 *  获取SDK版本号接口
 *
 *  @return 版本号
 */
+ (NSString *)getVersion;

#pragma mark - 初始化和销毁
/**
 *  初始化
 *
 *  @param authToken  服务端下发的access_token
 *  @param completion 异步结果回调
 
 *  @return YES/NO
 */
+ (BOOL)initSDKWithAuthToken:(NSString *)authToken
                  completion:(void(^)(BOOL succeed, NSError *error))completion;

/**
 *  初始化
 *
 *  @param authToken  服务端下发的access_token
 *  @param tokenType  服务端下发的token_type,无值时可以传空
 *  @param completion 异步结果回调
 
 *  @return YES/NO
 */
+ (BOOL)initSDKWithAuthToken:(NSString *)authToken
                   tokenType:(NSString *)tokenType
                  completion:(void(^)(BOOL succeed, NSError *error))completion;

/**
 *
 *  销毁EZOpenSDK接口
 *
 *  @return YES/NO
 */
+ (BOOL)destorySDK;

#pragma mark - 视频预览
/**
 *  开始预览
 *
 *  @param view 播放视图
 *  @param deviceSerial 设备序列号
 *  @param channelNo     通道号
 *  @param verifyCode     验证码,加密设备用到
 *  @param completion 开始预览结果
 */
+ (void)startRealPlayinView:(UIView *)view
               deviceSerial:(NSString *)deviceSerial
                  channelNo:(NSInteger)channelNo
                 verifyCode:(NSString *)verifyCode
                 completion:(void(^)(BOOL succeed, NSError *error))completion;

/**
 结束预览
 */
+ (BOOL)stopRealPlay;

#pragma mark - 回放
/**
 *  查询云存储录像信息列表接口
 *
 *  @param deviceSerial 设备序列号
 *  @param channelNo    通道号
 *  @param beginTime    查询时间范围开始时间
 *  @param endTime      查询时间范围结束时间
 *  @param completion   回调block，正常时返回EZCloudRecordFile的对象数组，错误时返回错误码
 *  @exception 错误码类型：110004，具体参考EZConstants头文件中的EZErrorCode错误码注释
 *
 */
+ (void)searchRecordFileFromCloud:(NSString *)deviceSerial
                        channelNo:(NSInteger)channelNo
                        beginTime:(NSDate *)beginTime
                          endTime:(NSDate *)endTime
                       completion:(void (^)(NSArray *couldRecords, NSError *error))completion;

/**
 *  查询远程SD卡存储录像信息列表接口
 *
 *  @param deviceSerial 设备序列号
 *  @param channelNo    通道号
 *  @param beginTime    查询时间范围开始时间
 *  @param endTime      查询时间范围结束时间
 *  @param completion   回调block，正常时返回EZDeviceRecordFile的对象数组，错误时返回错误码
 *  @exception 错误码类型：110004，具体参考EZConstants头文件中的EZErrorCode错误码注释
 *
 */
+ (void)searchRecordFileFromDevice:(NSString *)deviceSerial
                         channelNo:(NSInteger)channelNo
                         beginTime:(NSDate *)beginTime
                           endTime:(NSDate *)endTime
                        completion:(void (^)(NSArray *deviceRecords, NSError *error))completion;
/**
 *  开始云存储远程回放，异步接口，返回值只是表示操作成功，不代表播放成功
 *  @param cloudFile 云存储文件信息
 *  @param deviceSerial 设备序列号
 *  @param channelNo    通道号
 *  @param verifyCode     验证码,加密设备用到
 *  @param completion 结果
 *  @return YES/NO
 */
+ (BOOL)startPlaybackFromCloud:(EZCloudRecordFile *)cloudFile
                        inView:(UIView *)view
                  deviceSerial:(NSString *)deviceSerial
                     channelNo:(NSInteger)channelNo
                    verifyCode:(NSString *)verifyCode
                    completion:(void(^)(BOOL succeed, NSError *error))completion;;

/**
 *  开始远程SD卡回放，异步接口，返回值只是表示操作成功，不代表播放成功
 *
 *  @param deviceFile SD卡文件信息
 *  @param deviceSerial 设备序列号
 *  @param channelNo    通道号
 *  @param verifyCode     验证码,加密设备用到
 *  @param completion 结果
 *  @return YES/NO
 */
+ (BOOL)startPlaybackFromDevice:(EZDeviceRecordFile *)deviceFile
                         inView:(UIView *)view
                   deviceSerial:(NSString *)deviceSerial
                      channelNo:(NSInteger)channelNo
                     verifyCode:(NSString *)verifyCode
                     completion:(void(^)(BOOL succeed, NSError *error))completion;;

/**
 *  停止远程回放
 */
+ (BOOL)stopPlayback;

/**
 SD卡回放专用接口，倍数回放
 
 @param rate 回放倍率，见EZPlaybackRate,目前设备存储回放支持1、2、4、8、1/2、1/4、1/8倍数
 @return YES/NO
 */
+ (BOOL)setPlaybackRate:(EZPlaybackRate)rate;

/**
 云存储回放专用接口，倍数回放
 
 @param rate 回放倍率，见EZCloudPlaybackRate,目前云存储支持1、4、8、16、32倍数
 @return YES/NO
 */
+ (BOOL)setCloudPlaybackRate:(EZPlaybackRate)rate;

#pragma mark - 对讲
/**
  *  开始对讲
  *  @param completion   回调block，succeed表示设置成功
 */
+ (BOOL)startVoiceTalk:(void(^)(BOOL succeed, NSError *error))completion;

/**
  *  关闭对讲 (注：startVoiceTalk 与 stopVoiceTalk 需成对调用)
  *  @param completion   回调block，无error表示设置成功
 */
+ (BOOL)stopVoiceTalk:(void(^)(BOOL succeed, NSError *error))completion;

/**
 *  半双工对讲专用接口，是否切换到听说状态
 *
 *  @param isPressed 是否只说状态
 *
 *  @return YES/NO
 */
+ (BOOL)audioTalkPressed:(BOOL)isPressed;

/**
 *  开始对讲（可视对讲专用）
 *  @param deviceSerial 设备序列号
 *  @param channelNo     通道号
 *  @param verifyCode     验证码,加密设备用到
 *  @param completion   回调block，succeed表示设置成功
 */
+ (BOOL)startVisualTalk:(NSString *)deviceSerial
              channelNo:(NSInteger)channelNo
            verifyCode:(NSString *)verifyCode
            completion:(void(^)(BOOL succeed, NSError *error))completion;

/**
 *  关闭对讲 (注：startVisualTalk 与 stopVisualTalk 需成对调用)
 *  @param completion   回调block，无error表示设置成功
 */
+ (BOOL)stopVisualTalk:(void(^)(BOOL succeed, NSError *error))completion;

/**
 设置全双工对讲时的模式,对讲成功后调用
 
 @param routeToSpeaker YES:使用扬声器 NO:使用听筒
 */
- (void) changeTalkingRouteMode:(BOOL) routeToSpeaker;

#pragma mark - 切换清晰度
/**
 *  设置设备通道的清晰度
 *
 *  @param deviceSerial 设备序列号
 *  @param channelNo    通道号
 *  @param videoLevel   通道清晰度，0-流畅，1-均衡，2-高清，3-超清
 *  @param completion   回调block，无error表示设置成功
 *  @see 如果是正在播放时调用该接口，设置清晰度成功以后必须调用stopRealPlay再调用startRealPlay重新取流才成完成画面清晰度的切换。
 *
 */
+ (void)setVideoLevel:(NSString *)deviceSerial
            channelNo:(NSInteger)channelNo
           videoLevel:(EZVideoLevelType)videoLevel
           completion:(void (^)(NSError *error))completion;

#pragma mark - 可视对讲

/**
 获取设备通话状态
 */
+ (void)listenDeviceStatus:(NSString *)deviceSerial
                completion:(void(^)(BOOL succeed, CloudDeviceCallStatus deviceCallStatus, NSError *error))completion;

/**
 接听
 
 @param completion 接听结果
 */
+ (void)answer:(CloudVoiceTalkParamsModel *)paramsModel
    completion:(void(^)(BOOL succeed, NSError *error))completion;

/**
 挂断
 
 @param completion 挂断结果
 */
+ (void)hangUp:(CloudVoiceTalkParamsModel *)paramsModel
    completion:(void(^)(BOOL succeed, NSError *error))completion;

/**
 拒接
 
 @param completion 拒接结果
 */
+ (void)reject:(CloudVoiceTalkParamsModel *)paramsModel
    completion:(void(^)(BOOL succeed, NSError *error))completion;

/**
 响铃超时
 
 @param completion 结果
 */
+ (void)bellTimeout:(CloudVoiceTalkParamsModel *)paramsModel
         completion:(void(^)(BOOL succeed, NSError *error))completion;

#pragma mark - 录像

/**
 *  开始本地录像功能（SDK处理存储过程）
 *
 *  @param path 文件存储路径
 *
 *  @return YES/NO
 */
+ (BOOL)startLocalRecordWithPath:(NSString *)path;

/**
 *  结束本地直播流录像
 *
 *  @return YES/NO
 */
+ (BOOL)stopLocalRecord:(void (^)(BOOL ret))complete;

#pragma mark - 拍照
/**
 *  直播画面抓图
 *
 *  @param quality 抓图质量（0～100）,数值越大图片质量越好，图片大小越大
 *
 *  @return image
 */
+ (UIImage *)capturePicture:(NSInteger)quality;

#pragma mark - 声音
/**
 *  开启声音
 *
 *  @return YES/NO
 */
+ (BOOL)openSound;

/**
 *  关闭声音
 *
 *  @return YES/NO
 */
+ (BOOL)closeSound;

#pragma mark - 根据序列号获取设备信息
/**
 *  根据序列号获取设备信息
 *
 *  @param deviceSerial 设备序列号
 *  @param completion 回调block，正常时返回EZDeviceInfo的对象，错误时返回错误码
 *
 */
+ (void)getDeviceInfo:(NSString *)deviceSerial
           completion:(void (^)(EZDeviceInfo *deviceInfo, NSError *error))completion;

#pragma mark - 云台操作
/**
 *  PTZ 控制接口
 *
 *  @param deviceSerial 设备序列号
 *  @param channelNo    通道号
 *  @param command      ptz控制命令
 *  @param action       控制启动/停止
 *  @param completion  回调block，当error为空时表示操作成功
 *
 */
+ (void)controlPTZ:(NSString *)deviceSerial
         channelNo:(NSInteger)channelNo
           command:(CloudVideoPTZCommand)command
            action:(CloudVideoPTZAction)action
        completion:(void(^)(BOOL succeed, NSError *error))completion;

#pragma mark - 日志
/**
 设置是否打印debug日志
 
 @param enable 是否打印日志，默认关闭
 @return YES/NO
 */
+ (BOOL)setDebugLogEnable:(BOOL)enable;

#pragma mark - 刷新token
/**
 *  刷新token,token过期时调用
 *
 *  @return YES/NO
 */
+ (BOOL)refreshToken:(NSString *)authToken;

@end
