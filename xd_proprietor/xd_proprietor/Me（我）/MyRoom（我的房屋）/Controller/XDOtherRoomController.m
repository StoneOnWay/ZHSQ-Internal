//
//  Created by cfsc on 2020/3/12.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDOtherRoomController.h"
#import "XDRoomListCell.h"
#import "XDRoomMemberController.h"

@interface XDOtherRoomController ()
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation XDOtherRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"XDRoomListCell" bundle:nil] forCellReuseIdentifier:@"XDRoomListCell"];
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRoomData)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView.mj_header beginRefreshing];
    [self loadRoomData];
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}

- (void)loadRoomData {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
//    [MBProgressHUD showActivityMessageInView:nil];
    WEAKSELF
    [XDHTTPRequst getRoomVerifyListWithHouseholdId:loginInfo.userModel.userID succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.itemArray removeAllObjects];
            // 待审核和审核失败的房屋
            for (NSDictionary *dic in res[@"result"]) {
                XDRoomModel *roomModel = [XDRoomModel mj_objectWithKeyValues:dic];
                [weakSelf.itemArray addObject:roomModel];
            }
            // 除当前房屋以外的房屋
            for (XDRoomModel *model in loginInfo.userModel.roomList) {
                if (![model.roomId isEqualToString:loginInfo.userModel.currentDistrict.roomId]) {
                    [weakSelf.itemArray addObject:model];
                }
            }
            [self.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUD];
        } else {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDRoomModel *model = self.itemArray[indexPath.row];
    XDRoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDRoomListCell" forIndexPath:indexPath];
    [cell setContentWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDRoomModel *model = self.itemArray[indexPath.row];
    if (model.approvalStatus == 1) {
        // 待审核，微信通知待开发
//        [MBProgressHUD showTipMessageInView:@"待审核，微信通知待开发!" timer:2];
    } else if (model.approvalStatus == 3) {
        // 审核被拒绝的处理
//        [MBProgressHUD showTipMessageInView:@"审核被拒绝!" timer:2];
    } else {
        // 显示该房屋的住户信息，并可以切换到此房屋
        XDRoomMemberController *roomMemVC = [[XDRoomMemberController alloc] init];
        roomMemVC.roomModel = model;
        roomMemVC.title = @"房屋成员";
        [self.navigationController pushViewController:roomMemVC animated:YES];
    }
}

@end
