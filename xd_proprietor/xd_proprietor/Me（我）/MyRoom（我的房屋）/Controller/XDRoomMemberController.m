//
//  Created by cfsc on 2020/3/12.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDRoomMemberController.h"
#import "XDCurrentRoomView.h"
#import "XDRoomMemberCell.h"
#import "XDUnitSelectController.h"
#import "XDFaceManageController.h"
#import "XDDevicePermissionController.h"

@interface XDRoomMemberController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) XDCurrentRoomView *roomView;
@property (weak, nonatomic) IBOutlet UIView *noRoomTipView;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addRoomBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewHeightConstaint;
@property (weak, nonatomic) IBOutlet UIButton *footerButton;

@end

@implementation XDRoomMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self configNoRoomTipView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadCurrentRoomInfo];
}

- (void)configTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XDRoomMemberCell" bundle:nil] forCellReuseIdentifier:@"XDRoomMemberCell"];
    XDCurrentRoomView *roomView = [[XDCurrentRoomView alloc] init];
    roomView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    self.roomView = roomView;
    self.tableView.tableHeaderView = roomView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.footerButton.layer.cornerRadius = 5;
    self.footerButton.layer.masksToBounds = YES;
    self.footerViewHeightConstaint.constant = 0;
    [self.view layoutIfNeeded];
}

- (void)configNoRoomTipView {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    self.userIconImageView.layer.cornerRadius = 25.f;
    self.userIconImageView.layer.masksToBounds = YES;
    self.addRoomBtn.layer.borderColor = RGB(234, 119, 104).CGColor;
    self.addRoomBtn.layer.borderWidth = 0.5;
    self.addRoomBtn.layer.cornerRadius = 15;
    self.addRoomBtn.layer.masksToBounds = YES;
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:loginInfo.userModel.avatarResource.url] placeholderImage:[UIImage imageNamed:@"tsxq2_user"]];
    self.userNameLabel.text = loginInfo.userModel.name;
}

- (IBAction)footerButtonAciton:(id)sender {
    // 切换房屋
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    // 更新服务器上用户绑定的projectID
    if (!loginInfo.userModel.userID || !self.roomModel.projectId || !self.roomModel.phaseId || !self.roomModel.buildingId || !self.roomModel.unitId || !self.roomModel.roomId) {
        [MBProgressHUD showTipMessageInWindow:@"字典value为空，防止崩溃提示！" timer:2];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSDictionary *dic = @{
                          @"householdId":loginInfo.userModel.userID,
                          @"projectId":self.roomModel.projectId,
                          @"phaseId":self.roomModel.phaseId,
                          @"unitId":self.roomModel.unitId,
                          @"buildingId":self.roomModel.buildingId,
                          @"roomId":self.roomModel.roomId
                          };
    [XDHTTPRequst selectCurrentBindingWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            // 更新本地用户信息并进入首页
            [XDHTTPRequst getUserInfoCacheSucceed:^(id res) {
                if ([res[@"code"] integerValue] == 200) {
                    XDUserModel *userModel = [XDUserModel mj_objectWithKeyValues:res[@"result"]];
                    loginInfo.userModel = userModel;
                    [XDArchiverManager saveLoginInfo:loginInfo];
                    [[XDCommonBusiness shareInstance] setPushTagsAndAlias];
                    [MBProgressHUD hideHUD];
                    // 进入首页
                    UIWindow *window = [[UIApplication sharedApplication].delegate window];
                    [AppDelegate shareAppDelegate].tabBarViewController = [[BaseTabBarViewController alloc]init];
                    window.rootViewController = [AppDelegate shareAppDelegate].tabBarViewController;
                } else {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showTipMessageInWindow:res[@"message"] timer:2];
                }
            } fail:^(NSError *error) {
                NSLog(@"getUserInfoError--%@", error);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:@"请求超时，请稍后再试！" timer:2];
            }];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInWindow:@"请求超时，请稍后再试！" timer:2];
    }];
}

//  加载房屋数据
- (void)loadCurrentRoomInfo {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *roomId = @"";
    if (self.roomModel) {
        // 切换房屋页面
        roomId = self.roomModel.roomId;
        self.noRoomTipView.hidden = YES;
        self.footerViewHeightConstaint.constant = 70;
        [self.view layoutIfNeeded];
    } else {
        // 当前房屋页面
        roomId = loginInfo.userModel.currentDistrict.roomId;
        if (!roomId) {
            // 当前房屋为空
            self.noRoomTipView.hidden = NO;
            self.roomView.projectName = loginInfo.userModel.currentDistrict.projectName;
            return;
        } else {
            self.noRoomTipView.hidden = YES;
        }
    }
//    [MBProgressHUD showActivityMessageInView:nil];
    NSMutableArray *otherUserArray = [[NSMutableArray alloc] init];
    WEAKSELF
    [XDHTTPRequst getRoomInfoWithRoomId:roomId succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.itemArray removeAllObjects];
            XDRoomModel *model = [XDRoomModel mj_objectWithKeyValues:res[@"result"]];
            // 设置头部
            weakSelf.roomView.roomModel = model;
            // 设置列表
            for (XDUserModel *userModel in model.householdBoList) {
                if ([userModel.userID isEqualToString:loginInfo.userModel.userID]) {
                    [weakSelf.itemArray addObject:@[userModel]];
                } else {
                    [otherUserArray addObject:userModel];
                }
            }
            [weakSelf.itemArray addObject:otherUserArray];
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

- (IBAction)addRoomAction:(id)sender {
    XDUnitSelectController *roomSelVC = [[XDUnitSelectController alloc] init];
    [self.navigationController pushViewController:roomSelVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDUserModel *model = self.itemArray[indexPath.section][indexPath.row];
    XDRoomMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDRoomMemberCell" forIndexPath:indexPath];
    [cell setContentWithUser:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    NSString *str = section == 0 ? @"":@"房间其他住户";
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
    if (section == 0) {
        return 0;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    XDUserModel *currentUser = self.itemArray[0][0];
    XDUserModel *model = self.itemArray[indexPath.section][indexPath.row];
    if (model.joinStatus.integerValue != 1) {
        [XDUtil showToast:@"请先前往物业为该用户办理入伙手续"];
        return;
    }
    XDFaceManageController *faceMarVC = [[XDFaceManageController alloc] init];
    faceMarVC.userModel = model;
    if (self.roomModel) {
        // 切换房屋页面
        faceMarVC.roomId = self.roomModel.roomId;
        faceMarVC.phaseId = self.roomModel.phaseId;
        faceMarVC.unitId = self.roomModel.unitId;
    } else {
        // 当前房屋页面
        faceMarVC.roomId = loginInfo.userModel.currentDistrict.roomId;
        faceMarVC.phaseId = loginInfo.userModel.currentDistrict.phaseId;
        faceMarVC.unitId = loginInfo.userModel.currentDistrict.unitId;
    }
    if (indexPath.section == 0 || [currentUser.householdType isEqualToString:@"YZ"]) {
        // 当前登录用户或业主，可以跳转至自己的人脸管理界面
        [self.navigationController pushViewController:faceMarVC animated:YES];
    } else {
        [XDUtil showToast:@"非业主无权访问其他住户信息"];
    }
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}

@end
