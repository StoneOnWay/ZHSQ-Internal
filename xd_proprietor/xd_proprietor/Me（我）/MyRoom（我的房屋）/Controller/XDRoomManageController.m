//
//  Created by cfsc on 2020/3/13.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDRoomManageController.h"
#import "XDRoomListCell.h"
#import "XDProjectSelectController.h"
#import "XDRoomModel.h"
#import "XDRoomVerifyController.h"

typedef void(^CompletionHandel) (void);

@interface XDRoomManageController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation XDRoomManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理房屋";
    [self configTableView];
    [self loadRoomData];
}

- (void)configTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XDRoomListCell" bundle:nil] forCellReuseIdentifier:@"XDRoomListCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)loadRoomData {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    [MBProgressHUD showActivityMessageInView:nil];
    WEAKSELF
    NSMutableArray *currentRoomArray = [[NSMutableArray alloc] init];
    NSMutableArray *otherRoomArray = [[NSMutableArray alloc] init];
    [XDHTTPRequst getRoomVerifyListWithHouseholdId:loginInfo.userModel.userID succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            // 待审核和审核失败的房屋
            for (NSDictionary *dic in res[@"result"]) {
                XDRoomModel *roomModel = [XDRoomModel mj_objectWithKeyValues:dic];
                [otherRoomArray addObject:roomModel];
            }
            // 除当前房屋以外的房屋
            for (XDRoomModel *model in loginInfo.userModel.roomList) {
                if (![model.roomId isEqualToString:loginInfo.userModel.currentDistrict.roomId]) {
                    [otherRoomArray addObject:model];
                } else {
                    [currentRoomArray addObject:model];
                }
            }
            [weakSelf.itemArray addObject:currentRoomArray];
            [weakSelf.itemArray addObject:otherRoomArray];
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDRoomModel *model = self.itemArray[indexPath.section][indexPath.row];
    XDRoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDRoomListCell" forIndexPath:indexPath];
    [cell setContentWithModel:model];
    if ([model.householdType isEqualToString:@"JS"] || [model.householdType isEqualToString:@"ZH"]) {
        cell.rightImageView.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *str = section == 0 ? @"当前房屋":@"其他房屋";
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = litterBackColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 30)];
    label.text = str;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor lightGrayColor];
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.itemArray[section] count] == 0) {
        return 0;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XDRoomModel *model = self.itemArray[indexPath.section][indexPath.row];
    if ([model.householdType isEqualToString:@"YZ"]) {
        // 身份是业主的房屋可以进去管理审核记录
        XDRoomVerifyController *roomVerifyVC = [[XDRoomVerifyController alloc] init];
        roomVerifyVC.roomModel = model;
        [self.navigationController pushViewController:roomVerifyVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *roomArray = self.itemArray[indexPath.section];
    XDRoomModel *model = roomArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (model.approvalStatus == 1) {
            // 待审核的房屋
            [self deleteRoomWithTips:@"待审核的房屋暂时无法删除" completionHandel:nil type:1];
        } else if (model.approvalStatus == 3) {
            // 审核不通过的房屋
            [self deleteRoomWithTips:@"是否确认删除该条记录？" completionHandel:^{
                [self deleteRoomVerifyRecord:model roomArray:roomArray];
            } type:2];
        } else {
            [self deleteRoomWithTips:@"删除此房屋会同时解除您与此房屋的所有绑定关系，是否确认删除？" completionHandel:^{
                [self deleteBindedRoom:model roomArray:roomArray];
            } type:2];
        }
    }
}

// 删除已绑定房屋
- (void)deleteBindedRoom:(XDRoomModel *)bindedModel roomArray:(NSMutableArray *)roomArray {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSMutableDictionary *roomMap = [[NSMutableDictionary alloc] init];
    for (XDRoomModel *model in loginInfo.userModel.roomList) {
        if (![model.roomId isEqualToString:bindedModel.roomId]) {
            [roomMap setValue:model.householdType forKey:model.roomId];
        }
    }
    WEAKSELF
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
                          @"roomMap":roomMap,
                          @"id":loginInfo.userModel.userID
                          };
    // 更改用户信息：房屋信息
    [XDHTTPRequst updateUserInfoWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            if ([bindedModel.roomId isEqualToString:loginInfo.userModel.currentDistrict.roomId]) {
                // 如果删除的是当前房屋，需要更新当前选择的小区信息
                [weakSelf updateCurrentDistrict:bindedModel roomArray:roomArray loginInfo:loginInfo];
            } else {
                // 仅删除房屋
                [weakSelf updateLocalInfo:bindedModel roomArray:roomArray loginInfo:loginInfo];
            }
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 更新本地数据后刷新界面
- (void)updateLocalInfo:(XDRoomModel *)bindedModel roomArray:(NSMutableArray *)roomArray loginInfo:(XDLoginInfoModel *)loginInfo {
    WEAKSELF
    // 更新本地用户信息并返回首页
    [XDHTTPRequst getUserInfoCacheSucceed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            XDUserModel *userModel = [XDUserModel mj_objectWithKeyValues:res[@"result"]];
            loginInfo.userModel = userModel;
            [XDArchiverManager saveLoginInfo:loginInfo];
            // 更新UI
            [roomArray removeObject:bindedModel];
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        NSLog(@"getUserInfoError--%@", error);
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 更新当前绑定的房屋和小区
- (void)updateCurrentDistrict:(XDRoomModel *)bindedModel roomArray:(NSMutableArray *)roomArray loginInfo:(XDLoginInfoModel *)loginInfo {
    NSDictionary *bindDic = @{
                              @"householdId":loginInfo.userModel.userID,
                              @"projectId":bindedModel.projectId
                              };
    // 更改用户绑定信息
    WEAKSELF
    [XDHTTPRequst selectCurrentBindingWithDic:bindDic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            // 更新本地用户信息并返回首页
            [XDHTTPRequst getUserInfoCacheSucceed:^(id res) {
                if ([res[@"code"] integerValue] == 200) {
                    XDUserModel *userModel = [XDUserModel mj_objectWithKeyValues:res[@"result"]];
                    loginInfo.userModel = userModel;
                    [XDArchiverManager saveLoginInfo:loginInfo];
                    [[XDCommonBusiness shareInstance] setPushTagsAndAlias];
                    // 更新UI
                    [roomArray removeObject:bindedModel];
                    [weakSelf.tableView reloadData];
                    [MBProgressHUD hideHUD];
                    // 进入首页
                    UIWindow *window = [[UIApplication sharedApplication].delegate window];
                    [AppDelegate shareAppDelegate].tabBarViewController = [[BaseTabBarViewController alloc]init];
                    window.rootViewController = [AppDelegate shareAppDelegate].tabBarViewController;
                } else {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
                }
            } fail:^(NSError *error) {
                NSLog(@"getUserInfoError--%@", error);
                [MBProgressHUD hideHUD];
                [XDHTTPRequst showErrorMessageWith:error];
            }];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 删除房屋审核记录
- (void)deleteRoomVerifyRecord:(XDRoomModel *)model roomArray:(NSMutableArray *)roomArray {
    [XDHTTPRequst deleteRoomVerifyRecordWithId:model.approvalId succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            [roomArray removeObject:model];
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)deleteRoomWithTips:(NSString *)tips completionHandel:(CompletionHandel)handel type:(NSInteger)type {
    UIViewController *rootVC = [[AppDelegate shareAppDelegate] topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:tips preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 删除房屋操作
        if (handel) {
            handel();
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertvc addAction:sureAction];
    if (type == 2) {
        [alertvc addAction:cancelAction];
    }
    [rootVC presentViewController:alertvc animated:YES completion:nil];
}

- (IBAction)addRoomAction:(id)sender {
    // 跳转至项目选择
    XDProjectSelectController *projectSelectVC = [[XDProjectSelectController alloc] init];
    projectSelectVC.canGoBack = YES;
    [self.navigationController pushViewController:projectSelectVC animated:YES];
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}

@end
