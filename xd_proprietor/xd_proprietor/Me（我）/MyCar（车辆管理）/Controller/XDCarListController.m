//
//  XDCarListController.m
//  xd_proprietor
//
//  Created by stone on 22/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDCarListController.h"
#import "XDCarListCell.h"
#import "XDCarManageController.h"
#import "XDVehicleModel.h"

@interface XDCarListController ()
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UILabel *footerLabel;
@end

@implementation XDCarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的车辆";
    
    [self setNavItem];
    [self configTableView];
    [self loadCarList];
}

- (void)setNavItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_jia" frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(addMyCars)];
}

- (void)configTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"XDCarListCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDCarListCell"];
    self.tableView.backgroundColor = litterBackColor;
    self.footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    self.footerLabel.font = [UIFont systemFontOfSize:14];
    self.footerLabel.textColor = RGB(88, 88, 88);
    self.footerLabel.text = @"没有车辆，请点击右上角添加一台吧";
    self.footerLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = self.footerLabel;
    self.footerLabel.hidden = YES;
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCarList)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
}

- (void)loadCarList {
    [MBProgressHUD showActivityMessageInView:nil];
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (!loginInfo.userModel.mobile || !loginInfo.userModel.currentDistrict.projectId) {
        return;
    }
    NSDictionary *dic = @{
        @"ownerPhone":loginInfo.userModel.mobile,
        @"pageNo":@1,
        @"pageSize":@100,
        @"projectId":loginInfo.userModel.currentDistrict.projectId
    };
    WEAKSELF
    [XDHTTPRequst getVehicleListWithDic:dic succeed:^(id res) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.itemArray removeAllObjects];
            NSArray *resultList = res[@"result"][@"data"];
            for (NSDictionary *dic in resultList) {
                XDVehicleModel *model = [XDVehicleModel mj_objectWithKeyValues:dic];
                if (model.type.integerValue == 1) {
                    model.typeName = @"临时车";
                } else if (model.type.integerValue == 2) {
                    model.typeName = @"包期车";
                } else if (model.type.integerValue == 3) {
                    model.typeName = @"群组车";
                }
                [weakSelf.itemArray addObject:model];
            }
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)addMyCars {
    XDCarManageController *carManVC = [[XDCarManageController alloc] init];
    carManVC.addCarSuccess = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:carManVC animated:YES];
}

- (void)deleteMyCarAtIndexPath:(NSIndexPath *)indexPath {
    XDVehicleModel *model = self.itemArray[indexPath.row];
    if (!model.vehicleId) {
        return;
    }
    [MBProgressHUD showActivityMessageInView:nil];
    WEAKSELF
    [XDHTTPRequst deleteVehicleWithVehicleIds:model.vehicleId succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.itemArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark - lazy load
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.itemArray.count == 0) {
        self.footerLabel.hidden = NO;
        self.footerLabel.frame = CGRectMake(0, 0, kScreenWidth, 60);
    } else {
        self.footerLabel.hidden = YES;
        self.footerLabel.frame = CGRectMake(0, 0, kScreenWidth, 0);
    }
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDVehicleModel *model = self.itemArray[indexPath.row];
    XDCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDCarListCell" forIndexPath:indexPath];
    cell.vehicleModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteMyCarAtIndexPath:indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDVehicleModel *model = self.itemArray[indexPath.row];
    XDCarManageController *carManVC = [[XDCarManageController alloc] init];
    carManVC.vehicleModel = model;
    carManVC.addCarSuccess = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:carManVC animated:YES];
}

@end
