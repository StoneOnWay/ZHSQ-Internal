//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDUserCurrentDistrictModel.h"
#import "XDRoomModel.h"
#import "XDEquipmentModel.h"
#import "XDResourceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDUserModel : NSObject <NSCoding>
// 用户ID
@property (nonatomic, copy) NSString *userID;
// 手机号
@property (nonatomic, copy) NSString *mobile;
// 头像id
@property (nonatomic, copy) NSString *avatarId;
// 头像信息
@property (nonatomic, strong) XDResourceModel *avatarResource;
// 人脸id
@property (nonatomic, copy) NSString *faceId;
// 人脸信息
@property (nonatomic, strong) XDResourceModel *faceResource;
// 名称
@property (nonatomic, copy) NSString *name;
// 昵称
@property (nonatomic, copy) NSString *nickName;
// 性别
@property (nonatomic, copy) NSString *gender;
// 生日
@property (nonatomic, copy) NSString *birthday;
// 默认卡号
@property (nonatomic, copy) NSString *defaultCardNo;
// 房屋列表
@property (nonatomic, copy) NSArray <XDRoomModel *> *roomList;
// 设备列表
@property (nonatomic, copy) NSArray <XDEquipmentModel *> *equipmentInfoBoList;
// 当前选择的小区和房屋
@property (nonatomic, strong) XDUserCurrentDistrictModel *currentDistrict;

// 作为房间成员是否入伙
@property (nonatomic, copy) NSString *joinStatus;
// 作为房间成员业主类型名
@property (nonatomic, copy) NSString *householdTypeDisplay;
// 作为房间成员业主类型
@property (nonatomic, copy) NSString *householdType;
@end

NS_ASSUME_NONNULL_END
