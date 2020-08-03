//
//  Created by cfsc on 2020/2/5.
//  Copyright © 2020年 cfsc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 服务器地址配置
// 本地服务器地址缓存
#define KServerIp [TheUserDefaults objectForKey:@"server_ip"]
// 开发环境IP
//#define KDevelopIp @"http://192.168.1.101:8888"
#define KDevelopIp @"http://10.222.5.14:8888"
// 生产环境IP
#define KProuductionIp @"https://smart.chanfinecloud.com"
// 测试环境IP
#define KTestIp @"http://10.88.0.58:9200"
//#define KTestIp @"http://222.240.190.70:9200"
// 工单服务器
#define KWorkOrderServe [KServerIp isEqualToString:KDevelopIp] ? @"" : @"/smart-workorder-ms"
// basic服务
#define KBasicServe [KServerIp isEqualToString:KDevelopIp] ? @"" : @"/smart-basic-ms"
// sms-manager服务
#define KSMSManagerServe [KServerIp isEqualToString:KDevelopIp] ? @"" : @"/sms-manager-ms"
// auth服务
#define KAuthServe [KServerIp isEqualToString:KDevelopIp] ? @"" : @"/api-auth"
// content服务
#define KContentServe [KServerIp isEqualToString:KDevelopIp] ? @"" : @"/smart-content-ms"
// sys服务
#define KUserServe [KServerIp isEqualToString:KDevelopIp] ? @"" : @"/api-user"
// community服务
#define KCommunityServe [KServerIp isEqualToString:KDevelopIp] ? @"" : @"/smart-iot-ms"
// file服务
#define KFileServe [KServerIp isEqualToString:KDevelopIp] ? @"" : @"/file-manager-ms"
// program服务
#define KProgramServe [KServerIp isEqualToString:KDevelopIp] ? @"" : @"/smart-program-ms"

// 热点关注类型ID
static NSString *const hotFocusTypeID = @"16f5aea04976f570db362344f46bce24";
// 轮播动态类型ID
static NSString *const bannerTypeID = @"16f0e1e6d35e4705598d03b49a4b39h2";
// 工程进度类型ID
static NSString *const workProgressTypeID = @"16f0e1e6d35e4705598d03b49a4b39a1";
// 入伙类型ID
static NSString *const joinTypeID = @"1707a68b6d245b87c6d91d6448da56b3";
// 社区公告类型ID
static NSString *const newsTypeID = @"16f0e1e6d35e4705598d03b49a4b39b4";


typedef void(^succeed) (id res);
typedef void(^fail) (NSError *error);

typedef NS_ENUM(NSInteger, XDFlowType) {
    XDFlowTypeOrder = 1, // 工单
    XDFlowTypeComplain // 投诉
};

@interface XDHTTPRequst : NSObject


/// 弹框展示错误信息
/// @param error AFN返回的错误
+ (void)showErrorMessageWith:(NSError *)error;

#pragma mark - login & regist

/**
 发送短信验证码

 @param phone 手机号
 @param succeed 成功
 @param fail 失败
 */
+ (void)sendSmsCodeWithPhone:(NSString *)phone succeed:(succeed)succeed fail:(fail)fail;

/**
 注册业主

 @param phone 手机号
 @param key 验证码的key
 @param validNo 验证码
 @param loginMode 登录模式，"MOBILE","QQ"等
 @param succeed 成功
 @param fail 失败
 */
+ (void)registHouseHolderWithPhoneNo:(NSString *)phone validKey:(NSString *)key validNo:(NSString *)validNo loginMode:(NSString *)loginMode succeed:(succeed)succeed fail:(fail)fail;

/**
 业主登录

 @param mobile 手机号
 @param key 验证码的key
 @param validNo 验证码
 @param succeed 成功
 @param fail 失败
 */
+ (void)loginHouseHolderWithMobile:(NSString *)mobile key:(NSString *)key validNo:(NSString *)validNo succeed:(succeed)succeed fail:(fail)fail;

/// 更新token
/// @param oldToken 老的token
/// @param succeed 成功
/// @param fail 失败
+ (void)refreshTokenWithOldToken:(NSString *)oldToken succeed:(succeed)succeed fail:(fail)fail;

#pragma mark - content

/**
 获取内容列表
 
 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)getContentListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 获取内容详情
 
 @param ID 内容ID
 @param succeed 成功
 @param fail 失败
 */
+ (void)getContnetDetailWithID:(NSString *)ID succeed:(succeed)succeed fail:(fail)fail;

/**
 更新内容浏览数(browseNum)、收藏数(collectionNum)、分享数(forwardNum)
 
 @param ID 内容ID
 @param field 需要更新的字段
 @param succeed 成功
 @param fail 失败
 */
+ (void)updateContentWithID:(NSString *)ID field:(NSString *)field succeed:(succeed)succeed fail:(fail)fail;

/**
 内容点赞
 
 @param ID 内容ID
 @param succeed 成功
 @param fail 失败
 */
+ (void)praiseContnetWithID:(NSString *)ID succeed:(succeed)succeed fail:(fail)fail;

/**
 内容取消点赞
 
 @param ID 内容ID
 @param succeed 成功
 @param fail 失败
 */
+ (void)cancelPraiseContnetWithID:(NSString *)ID succeed:(succeed)succeed fail:(fail)fail;

/// 获取活动列表数据
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)getActivityListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

#pragma mark - basic

/**
 选择当前绑定的小区或房屋
 
 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)selectCurrentBindingWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 根据手机号获取用户信息

 @param mobile 手机号
 @param phaseId 分期ID
 @param succeed 成功
 @param fail 失败
 */
+ (void)getUserInfoWithMobile:(NSString *)mobile phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail;

/**
 获取用户信息缓存

 @param succeed 成功
 @param fail 失败
 */
+ (void)getUserInfoCacheSucceed:(succeed)succeed fail:(fail)fail;

/**
 获取小区配置树

 @param succeed 成功
 @param fail 失败
 */
+ (void)getHouseCongfigTreeSucceed:(succeed)succeed fail:(fail)fail;

/**
 获取房屋列表

 @param unitID 单元ID
 @param pageNo 分页
 @param succeed 成功
 @param fail 失败
 */
+ (void)getRoomListWithUnitID:(NSString *)unitID pageNo:(NSInteger)pageNo succeed:(succeed)succeed fail:(fail)fail;

/**
 更新用户信息

 @param dic 数据字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)updateUserInfoWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 更新用户信息指定字段，接口内部会刷新用户信息缓存
 
 @param dic 数据字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)updateUserSpecificFieldWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 更新住户人脸
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)updateUserFaceIdWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 唯一性校验

 @param tableName `库名`.表名
 @param fieldName 字段名
 @param fieldValue 字段值
 @param dataId 数据ID，编辑校验时传值
 @param succeed 成功
 @param fail 失败
 */
+ (void)uniqueCheckWithTableName:(NSString *)tableName fieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue dataId:(NSString *)dataId succeed:(succeed)succeed fail:(fail)fail;

/**
 提交房屋身份审核

 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)confirmRoomVerifyWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 获取住户的待审核房屋(包含审核不通过)

 @param householdId 业主ID
 @param succeed 成功
 @param fail 失败
 */
+ (void)getRoomVerifyListWithHouseholdId:(NSString *)householdId succeed:(succeed)succeed fail:(fail)fail;

/**
 获取某个房屋的所有审核记录

 @param roomId 房间ID
 @param succeed 成功
 @param fail 失败
 */
+ (void)getAllVerifyListWithRoomId:(NSString *)roomId succeed:(succeed)succeed fail:(fail)fail;

/// 获取活动报名的人
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)getActivityParicipatorsWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 取消报名
/// @param participatId 报名id
/// @param succeed 成功
/// @param fail 失败
+ (void)cancelRegistActivityWithId:(NSString *)participatId succeed:(succeed)succeed fail:(fail)fail;

/// 活动报名
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)registActivityParticipatorWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 通过房屋审核

 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)passRoomVerifyWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 拒绝房屋审核

 @param verifyId 审核ID
 @param succeed 成功
 @param fail 失败
 */
+ (void)refuseRoomVerifyWithVerifyId:(NSString *)verifyId succeed:(succeed)succeed fail:(fail)fail;

/**
 获取房间信息

 @param roomId 房间ID
 @param succeed 成功
 @param fail 失败
 */
+ (void)getRoomInfoWithRoomId:(NSString *)roomId succeed:(succeed)succeed fail:(fail)fail;

/**
 删除房屋审核记录

 @param verifyId 审核ID
 @param succeed 成功
 @param fail 失败
 */
+ (void)deleteRoomVerifyRecordWithId:(NSString *)verifyId succeed:(succeed)succeed fail:(fail)fail;

/// 获取车辆列表
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)getVehicleListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 添加车辆
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)addVehicleWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 编辑车辆
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)editVehicleWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 删除车辆
/// @param vehicleIds 车辆Id
/// @param succeed 成功
/// @param fail 失败
+ (void)deleteVehicleWithVehicleIds:(NSString *)vehicleIds succeed:(succeed)succeed fail:(fail)fail;

#pragma mark - community

/**
 获取门禁开锁二维码

 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)getLockQrcodeWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 获取访客列表

 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)getVisitListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 添加新邀请

 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)addNewVisitWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 远程开门

 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)openLockWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 获取停车库列表
/// @param dic 参数字典
/// @param phaseId 分期Id
/// @param succeed 成功
/// @param fail 失败
+ (void)getParkingListWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail;

/// 车辆包期
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)vehicleCharterWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail;

/// 查询停车账单
/// @param dic 参数字典
/// @param phaseId 分期Id
/// @param succeed 成功
/// @param fail 失败
+ (void)getVehicleBillWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail;

/// 停车账单支付
/// @param dic 参数字典
/// @param phaseId 分期Id
/// @param succeed 成功
/// @param fail 失败
+ (void)payVehicleBillWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail;

/// 获取云眸token
/// @param phaseId 分期id
/// @param succeed 成功
/// @param fail 失败
+ (void)getPosidenTokenWithPhaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail;

/// 海康远程开门
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)hikRemoteOpenWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 获取车辆布控状态
/// @param dic 参数字典
/// @param phaseId 分期ID
/// @param succeed 成功
/// @param fail 失败
+ (void)getAlarmVehicleListWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail;

/// 添加布控车辆
/// @param dic 参数字典
/// @param phaseId 分期ID
/// @param succeed 成功
/// @param fail 失败
+ (void)addAlarmVehicleWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail;

/// 删除布控车辆
/// @param dic 参数字典
/// @param phaseId 分期ID
/// @param succeed 成功
/// @param fail 失败
+ (void)deleteAlarmVehicleWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail;

/// 获取车辆过车记录
/// @param dic 参数字典
/// @param phaseId 分期ID
/// @param succeed 成功
/// @param fail 失败
+ (void)getVehicleRecordWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail;

/// 获取物联设备列表
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)getEquipmentListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 获取人员物联权限列表
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)getAllPermissionsListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 一键下发人员权限到所有设备，包括人脸
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)accessPermissionWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 下发权限到指定设备
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)accessSinglePermissionWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

#pragma mark - WorkOrderServe

/**
 获取流程列表

 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)getFlowListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 查询待处理流程列表

 @param pageNo 分页编码
 @param type 类型 1-工单 2-流程
 @param succeed 成功
 @param fail 失败
 */
+ (void)getUntreatedFlowListWithPageNo:(NSInteger)pageNo type:(XDFlowType)type  succeed:(succeed)succeed fail:(fail)fail;

/**
 查询流程详细信息

 @param flowId 流程ID
 @param type 流程类型
 @param succeed 成功
 @param fail 失败
 */
+ (void)getFlowDetailWithFlowId:(NSString *)flowId type:(XDFlowType)type  succeed:(succeed)succeed fail:(fail)fail;

/**
 处理流程

 @param dic 表单数据字典
 @param type 流程类型
 @param succeed 成功
 @param fail 失败
 */
+ (void)commitFlowDataWithDic:(NSDictionary *)dic type:(XDFlowType)type succeed:(succeed)succeed fail:(fail)fail;

/**
 根据部门ID获取所有员工列表
 
 @param departIds 部门IDs
 @param succeed 成功
 @param fail 失败
 */
+ (void)getEmployeeListWithDepartIds:(NSString *)departIds Succeed:(succeed)succeed fail:(fail)fail;

/**
 获取主管列表
 
 @param succeed 成功
 @param fail 失败
 */
+ (void)getDirectorListSucceed:(succeed)succeed fail:(fail)fail;

/**
 获取用户列表

 @param succeed 成功
 @param fail 失败
 */
+ (void)getEmployeeListSucceed:(succeed)succeed fail:(fail)fail;

/**
 文件方式上传流程资源

 @param path 资源地址
 @param dic 参数字典
 @param name 对应后台表单的名字
 @param succeed 成功
 @param fail 失败
 */
+ (void)uploadFileWithPath:(NSString *)path dic:(NSDictionary *)dic name:(NSString *)name succeed:(succeed)succeed fail:(fail)fail;

/**
 流数据上传流程资源

 @param datas 资源流
 @param dic 参数字典
 @param name 对应后台表单的名字
 @param succeed 成功
 @param fail 失败
 */
+ (void)uploadFlowResourceWithFileDatas:(NSArray *)datas dic:(NSDictionary *)dic name:(NSString *)name succeed:(succeed)succeed fail:(fail)fail;

/**
 获取工单类型列表

 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)getOrderTypeListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 获取投诉类型列表
 
 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)getComplainTypeListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 创建工单

 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)createOrderWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 创建投诉
 
 @param dic 参数字典
 @param succeed 成功
 @param fail 失败
 */
+ (void)createComplainWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 获取投诉所有状态
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)getComplainStatusListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/// 获取工单所有状态
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)getOrderStatusListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

/**
 根据文件ID获取文件

 @param fileId 文件id
 @param succeed 成功
 @param fail 失败
 */
+ (void)getFlieWithId:(NSString *)fileId succeed:(succeed)succeed fail:(fail)fail;

#pragma mark - UserSever

/// 获取数据字典
/// @param code `库名`.表名,文本字段,code字段
/// @param succeed 成功
/// @param fail 失败
+ (void)getDictItemsWithCode:(NSString *)code succeed:(succeed)succeed fail:(fail)fail;

/// 获取主键Id
/// @param succeed 成功
/// @param fail 失败
+ (void)getUserGenerateIdSucceed:(succeed)succeed fail:(fail)fail;

/// 获取App启动广告图
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)getAppAdvertImageWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

#pragma mark - ProgramServe

/// 获取所有应用
/// @param succeed 成功
/// @param fail 失败
+ (void)getAllProgramsSucceed:(succeed)succeed fail:(fail)fail;

/// 更新我的应用
/// @param dic 参数字典
/// @param succeed 成功
/// @param fail 失败
+ (void)updateMyProgramsWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail;

@end
