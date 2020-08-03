//
//  Created by cfsc on 2020/2/5.
//  Copyright © 2020年 cfsc. All rights reserved.
//

#import "XDHTTPRequst.h"
#import "AFHTTPSessionManager.h"

@implementation XDHTTPRequst

+ (void)showErrorMessageWith:(NSError *)error {
    NSData *receiveData =error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSString *receiveStr = [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
    // 字符串再生成NSData
    NSData *data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    // 再解析
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSString *msg = jsonDict.mj_JSONString ? jsonDict.mj_JSONString : @"请求超时";
//    msg = @"请求超时，请稍后再试！";
    [XDUtil showToast:msg];
}

+ (void)sendSmsCodeWithPhone:(NSString *)phone succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/sms-internal/codes";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KSMSManagerServe, urlString];
    NSDictionary *dic = @{
                          @"phone":phone
                          };
    [[XDRequstManager sharedManager] POST:totalString parameters:dic succend:^(id res) {
        succeed(res);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

+ (void)registHouseHolderWithPhoneNo:(NSString *)phone validKey:(NSString *)key validNo:(NSString *)validNo loginMode:(NSString *)loginMode succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/householdInfo/register";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    NSDictionary *dic = @{
                          @"mobile":phone,
                          @"validKey":key,
                          @"validCode":validNo,
                          @"loginMode":loginMode
                          };
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id res) {
        succeed(res);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

+ (void)loginHouseHolderWithMobile:(NSString *)mobile key:(NSString *)key validNo:(NSString *)validNo succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/oauth/user/household/login";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KAuthServe, urlString];
    NSDictionary *dic = @{
                          @"mobile":mobile,
                          @"key":key,
                          @"validCode":validNo
                          };
    [[XDRequstManager sharedManager] POST:totalString parameters:dic succend:^(id res) {
        succeed(res);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

+ (void)refreshTokenWithOldToken:(NSString *)oldToken succeed:(succeed)succeed fail:(fail)fail {
    if (!oldToken) {
        return;
    }
    NSString *urlString = @"/oauth/refresh/token";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KAuthServe, urlString];
    NSDictionary *dic = @{
                          @"access_token":oldToken
                          };
    [[XDRequstManager sharedManager] POST:totalString parameters:dic succend:^(id res) {
        succeed(res);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

+ (void)getUserInfoWithMobile:(NSString *)mobile phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail {
    if (!phaseId) {
        phaseId = @"";
    }
    if (!mobile) {
        mobile = @"";
    }
    NSString *urlString = @"/basic/householdInfo/phone";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    NSDictionary *dic = @{
                          @"phoneNumber":mobile,
                          @"phaseId":phaseId
                          };
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getUserInfoCacheSucceed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/householdInfo/currentHousehold";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
//    NSString *urlString = @"/basic/householdInfo/household-anon/refresh";
//    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
//    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
//        if ([resp[@"code"] integerValue] == 200) {
//        } else {
//            succeed(resp);
//        }
//    } fail:^(NSError *errors) {
//        fail(errors);
//    }];
}

+ (void)getHouseCongfigTreeSucceed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/project/tree";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getRoomListWithUnitID:(NSString *)unitID pageNo:(NSInteger)pageNo succeed:(succeed)succeed fail:(fail)fail {
    if (!unitID) {
        unitID = @"";
    }
    NSString *urlString = @"/basic/room/page";
    NSDictionary *dic = @{
                          @"pageNo":@(pageNo),
                          @"pageSize":@(PageSiz),
                          @"unitId":unitID
                          };
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)updateUserInfoWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/householdInfo";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] PUT:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)updateUserSpecificFieldWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/householdInfo/specificField";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] PUT:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)updateUserFaceIdWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/householdInfo/face";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] PUT:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getContentListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/smart/content/pages";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KContentServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getContnetDetailWithID:(NSString *)ID succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/smart/content/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KContentServe, urlString, ID];
    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)updateContentWithID:(NSString *)ID field:(NSString *)field succeed:(succeed)succeed fail:(fail)fail {
    if (!ID || !field) {
        return;
    }
    NSDictionary *dic = @{
                          @"announcementId":ID,
                          @"field":field
                          };
    NSString *urlString = @"/smart/contentThumbup/annoucementUp";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KContentServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)praiseContnetWithID:(NSString *)ID succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/smart/contentThumbup/likeAnnouncement/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KContentServe, urlString, ID];
    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)cancelPraiseContnetWithID:(NSString *)ID succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/smart/contentThumbup/noLikeAnnouncement/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KContentServe, urlString, ID];
    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getActivityListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/smart/event/page";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KContentServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getActivityParicipatorsWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/smart/event/detail";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KContentServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)cancelRegistActivityWithId:(NSString *)participatId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/smart/event/v2/cancel-registration";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KContentServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString parameters:@{@"id":participatId} succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)registActivityParticipatorWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/smart/event/v2/registration";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KContentServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)selectCurrentBindingWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/current/bind";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
};

+ (void)uniqueCheckWithTableName:(NSString *)tableName fieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue dataId:(NSString *)dataId succeed:(succeed)succeed fail:(fail)fail {
    if (!dataId) {
        dataId = @"";
    }
    NSDictionary *dic = @{
                          @"tableName":tableName,
                          @"fieldName":fieldName,
                          @"fieldValue":fieldValue,
                          @"dataId":dataId
                          };
    NSString *urlString = @"/sys/check/unique";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KUserServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)confirmRoomVerifyWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/verify";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getRoomVerifyListWithHouseholdId:(NSString *)householdId succeed:(succeed)succeed fail:(fail)fail {
    if (!householdId) {
        householdId = @"";
    }
    NSString *urlString = @"/basic/verify/pendingList";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    NSDictionary *dic = @{
                          @"householdId":householdId
                          };
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getAllVerifyListWithRoomId:(NSString *)roomId succeed:(succeed)succeed fail:(fail)fail {
    if (!roomId) {
        roomId = @"";
    }
    NSString *urlString = @"/basic/verify/page";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@100,
                          @"roomId":roomId
                          };
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)passRoomVerifyWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/verify/bind";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)refuseRoomVerifyWithVerifyId:(NSString *)verifyId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/verify";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    NSDictionary *dic = @{@"id":verifyId};
    [[XDRequstManager sharedManager] PUT:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getRoomInfoWithRoomId:(NSString *)roomId succeed:(succeed)succeed fail:(fail)fail {
    if (!roomId) {
        roomId = @"";
    }
    NSString *urlString = @"/basic/room/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KBasicServe, urlString, roomId];
    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)deleteRoomVerifyRecordWithId:(NSString *)verifyId succeed:(succeed)succeed fail:(fail)fail {
    if (!verifyId) {
        verifyId = @"";
    }
    NSString *urlString = @"/basic/verify/delete/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    NSDictionary *dic = @{
                          @"id":verifyId
                          };
    [[XDRequstManager sharedManager] DELETE:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getLockQrcodeWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/access/v1/qrcode/owner";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KCommunityServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getVisitListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/access/v1/visitor/pages";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KCommunityServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)addNewVisitWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/access/v1/qrcode/visitor";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KCommunityServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)openLockWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/access/v1/remote/open";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KCommunityServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getParkingListWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/car/v1/parking/list/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KCommunityServe, urlString, phaseId];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)vehicleCharterWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/car/v1/charge/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KCommunityServe, urlString, phaseId];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getVehicleBillWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/car/v1/pay/bill/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KCommunityServe, urlString, phaseId];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)payVehicleBillWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/car/v1/pay/receipt/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KCommunityServe, urlString, phaseId];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getPosidenTokenWithPhaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/access/v1/poseidon/token";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KCommunityServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:@{@"phaseId":phaseId} succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)hikRemoteOpenWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/access/v1/remote/open";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KCommunityServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getAlarmVehicleListWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/car/v1/alarm/list/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KCommunityServe, urlString, phaseId];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)addAlarmVehicleWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/car/v1/alarm/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KCommunityServe, urlString, phaseId];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)deleteAlarmVehicleWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/car/v1/alarm/deletion/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KCommunityServe, urlString, phaseId];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getVehicleRecordWithDic:(NSDictionary *)dic phaseId:(NSString *)phaseId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/car/v1/cross/list/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KCommunityServe, urlString, phaseId];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getEquipmentListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/access/v1/devices/user";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KCommunityServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getAllPermissionsListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/access/v1/person/list";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KCommunityServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)accessPermissionWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/access/v1/person/re-distribute/all";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KCommunityServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)accessSinglePermissionWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/community/api/access/v1/person/re-distribute/single";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KCommunityServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getVehicleListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/vehicleInfo/vehiclePage";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getDictItemsWithCode:(NSString *)code succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/sys/dict/items/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KUserServe, urlString, code];
    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)addVehicleWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/vehicleInfo/add";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)deleteVehicleWithVehicleIds:(NSString *)vehicleIds succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/vehicleInfo/delete/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KBasicServe, urlString, vehicleIds];
    [[XDRequstManager sharedManager] DELETE:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)editVehicleWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/basic/vehicleInfo/update";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KBasicServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getFlowListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/workflow/api/page";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KWorkOrderServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getUntreatedFlowListWithPageNo:(NSInteger)pageNo type:(XDFlowType)type  succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/workflow/api/todo";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KWorkOrderServe, urlString];
    NSDictionary *jsonDic = @{
                              @"pageNo":@(pageNo),
                              @"pageSize":@(PageSiz),
                              @"type":@(type)
                              };
    [[XDRequstManager sharedManager] GET:totalString parameters:jsonDic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getFlowDetailWithFlowId:(NSString *)flowId type:(XDFlowType)type succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/workflow/api/detail/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KWorkOrderServe, urlString, flowId];
    NSDictionary *dic = @{
                          @"type":@(type)
                          };
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)commitFlowDataWithDic:(NSDictionary *)dic type:(XDFlowType)type succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/workflow/api/push/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%ld", KServerIp, KWorkOrderServe, urlString, (long)type];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id res) {
        succeed(res);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

+ (void)getEmployeeListWithDepartIds:(NSString *)departIds Succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/sys/user/departStaff";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KUserServe, urlString];
    NSDictionary *dic = @{
                          @"departIds":departIds
                          };
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getDirectorListSucceed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/sys/user/departSupervisor";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KUserServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getEmployeeListSucceed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/sys/user/list";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KUserServe, urlString];
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@100
                          };
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)uploadFileWithPath:(NSString *)path dic:(NSDictionary *)dic name:(NSString *)name succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/files-anon";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KFileServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString parameters:dic name:name constructingBodyWithFilePath:path succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)uploadFlowResourceWithFileDatas:(NSArray *)datas dic:(NSDictionary *)dic name:(NSString *)name succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/files/bytes";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KFileServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic name:name constructingBodyWithBlock:datas succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getFlieWithId:(NSString *)fileId succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/files/byid/";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@%@", KServerIp, KFileServe, urlString, fileId];
    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getOrderTypeListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/work/orderType/pageByCondition";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KWorkOrderServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getComplainTypeListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/work/complaintType/pageByCondition";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KWorkOrderServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getComplainStatusListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/work/complaintStatus/complaintStatusList";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KWorkOrderServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getOrderStatusListWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/work/orderStatus/selectWorkorderStatus";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KWorkOrderServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)createOrderWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/workflow/api/workorder";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KWorkOrderServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id res) {
        succeed(res);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

+ (void)createComplainWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/workflow/api/complaint";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KWorkOrderServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id res) {
        succeed(res);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

+ (void)getUserGenerateIdSucceed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/sys/user/generateId";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KUserServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:nil succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getAppAdvertImageWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/sys/startup-diagram/effective";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KUserServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)getAllProgramsSucceed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/program/api/person";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KProgramServe, urlString];
    [[XDRequstManager sharedManager] GET:totalString parameters:@{@"platformType":@"CFL"} succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

+ (void)updateMyProgramsWithDic:(NSDictionary *)dic succeed:(succeed)succeed fail:(fail)fail {
    NSString *urlString = @"/program/api/person";
    NSString *totalString = [NSString stringWithFormat:@"%@%@%@", KServerIp, KProgramServe, urlString];
    [[XDRequstManager sharedManager] POST:totalString jsonParameters:dic succend:^(id resp) {
        succeed(resp);
    } fail:^(NSError *errors) {
        fail(errors);
    }];
}

@end


