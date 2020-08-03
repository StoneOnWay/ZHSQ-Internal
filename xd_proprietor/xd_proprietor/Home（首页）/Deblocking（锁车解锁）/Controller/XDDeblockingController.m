//
//  XDDeblockingController.m
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDDeblockingController.h"
#import "XDDelockingHeadView.h"
#import "XDDelockingCarCell.h"
#import "XDDelockingCell.h"
#import "GSPopoverViewController.h"
#import "XDTypePopCell.h"

#import "XDVehicleModel.h"
#import "XDVehicleAlarmModel.h"
#import "XDVehicleRecordModel.h"

@interface XDDeblockingController () <CustomAlertViewDelegate>

// 弹出框
@property (strong, nonatomic) GSPopoverViewController *popView;
// pop的contentView
@property (strong, nonatomic) UITableView *popTableView;
// 车辆的集合
@property (strong, nonatomic) NSMutableArray *carsArray;
// 车辆出入记录
@property (strong, nonatomic) NSMutableArray *carsRecordArray;
// 当前显示的车辆
@property (strong, nonatomic) XDVehicleModel *carModel;

@end

@implementation XDDeblockingController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self = [super initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"智能锁车";
    self.tableView.backgroundColor = litterBackColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshCarRecord)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
    
    [self loadCarList];
}

#pragma mark -- data

- (void)refreshCarRecord {
    [MBProgressHUD showActivityMessageInWindow:nil];
    [self getCarRecord];
}

// 车辆取消布控
- (void)deleteAlarmCar {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *phaseId = loginInfo.userModel.currentDistrict.phaseId;
    if (!self.carModel.plateNO || !phaseId) {
        return;
    }
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
        @"alarmSyscodes":self.carModel.alarmSyscode
    };
    WEAKSELF
    [XDHTTPRequst deleteAlarmVehicleWithDic:dic phaseId:phaseId succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            weakSelf.carModel.state = @1;
            weakSelf.carModel.alarmSyscode = nil;
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 车辆布控
- (void)addAlarmCar {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *phaseId = loginInfo.userModel.currentDistrict.phaseId;
    if (!self.carModel.plateNO || !phaseId) {
        return;
    }
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
        @"plateNo":self.carModel.plateNO,
    };
    WEAKSELF
    [XDHTTPRequst addAlarmVehicleWithDic:dic phaseId:phaseId succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            XDVehicleAlarmModel *alarmModel = [XDVehicleAlarmModel mj_objectWithKeyValues:res[@"result"]];
            weakSelf.carModel.state = @0;
            weakSelf.carModel.alarmSyscode = alarmModel.alarmSyscode;
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 获取车辆列表
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
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.carsArray removeAllObjects];
            NSArray *resultList = res[@"result"][@"data"];
            for (NSDictionary *dic in resultList) {
                XDVehicleModel *model = [XDVehicleModel mj_objectWithKeyValues:dic];
                if (model.auditStatus.integerValue == 1) {
                    [weakSelf.carsArray addObject:model];
                }
            }
            if (weakSelf.carsArray.count != 0) {
                weakSelf.carModel = weakSelf.carsArray[0];
                [weakSelf.tableView reloadData];
                [weakSelf getAlarmCars];
            } else {
                [weakSelf clickToAlertViewTitle:@"暂无车辆" withDetailTitle:@"请先至“我的-我的车辆”中添加车辆信息"];
                [MBProgressHUD hideHUD];
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

// 获取布控车辆
- (void)getAlarmCars {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *phaseId = loginInfo.userModel.currentDistrict.phaseId;
    if (!self.carModel.plateNO || !phaseId) {
        return;
    }
    NSDictionary *dic = @{
        @"searchKey":self.carModel.plateNO,
        @"pageNo": @1,
        @"pageSize": @1000,
    };
    WEAKSELF
    [XDHTTPRequst getAlarmVehicleListWithDic:dic phaseId:phaseId succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            NSArray *list = res[@"result"][@"list"];
            if (list.count == 0) {
                weakSelf.carModel.state = @(1);
            } else {
                XDVehicleAlarmModel *alarmModel = [XDVehicleAlarmModel mj_objectWithKeyValues:list.firstObject];
                weakSelf.carModel.alarmSyscode = alarmModel.alarmSyscode;
                weakSelf.carModel.state = @(0);
            }
            [weakSelf.tableView reloadData];
            [weakSelf getCarRecord];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 获取车辆出入记录
- (void)getCarRecord {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *phaseId = loginInfo.userModel.currentDistrict.phaseId;
    if (!self.carModel.plateNO || !phaseId) {
        return;
    }
    NSDictionary *dic = @{
        @"plateNo":self.carModel.plateNO,
        @"pageNo": @1,
        @"pageSize": @1000,
    };
    WEAKSELF
    [XDHTTPRequst getVehicleRecordWithDic:dic phaseId:phaseId succeed:^(id res) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.carsRecordArray removeAllObjects];
            NSArray *list = res[@"result"][@"list"];
            for (NSDictionary *dic in list) {
                XDVehicleRecordModel *record = [XDVehicleRecordModel mj_objectWithKeyValues:dic];
                if (record.vehicleOut.intValue == 0) {
                    record.inTime = record.crossTime;
                } else {
                    record.outTime = record.crossTime;
                }
                [weakSelf.carsRecordArray addObject:record];
            }
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark -- Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.carsArray.count == 0) {
        return 0;
    }
    if (tableView == self.tableView) {
        if (section == 1) {
            return self.carsRecordArray.count;
        }
        return 1;
    } else {
        return self.carsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            XDDelockingCarCell __block *cell = [XDDelockingCarCell cellWithTableView:tableView];
            if ([self.carModel.state isEqual: @(1)]) {
                cell.switchBtn.selected = YES;
                cell.isLock.text = @"解锁";
                cell.lockImage.image = [UIImage imageNamed:@"suo_kai"];
            } else {
                cell.switchBtn.selected = NO;
                cell.isLock.text = @"锁车";
                cell.lockImage.image = [UIImage imageNamed:@"suo_guan"];
            }
            __weak typeof(self)weakSelf = self;
            cell.switchBtnBlock = ^(UIButton *button) {
                if ([weakSelf.carModel.state isEqual:@1] && !weakSelf.carModel.alarmSyscode) {
                    [weakSelf addAlarmCar];
                } else if ([weakSelf.carModel.state isEqual:@0] && weakSelf.carModel.alarmSyscode) {
                    // 取消布控
                    [weakSelf deleteAlarmCar];
                } else {
                    [XDUtil showToast:@"服务器异常，请稍后再试"];
                }
            };
            cell.selectionStyle = 0;
            return cell;
        } else {
            XDDelockingCell *cell = [XDDelockingCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            XDVehicleRecordModel *model = self.carsRecordArray[indexPath.row];
            cell.recordModel = model;
            return cell;
        }
    } else {
        XDTypePopCell *cell = [XDTypePopCell cellWithTableView:tableView];
        XDVehicleModel *carModel = self.carsArray[indexPath.row];
        cell.textLabels.text = [NSString stringWithFormat:@"%@", carModel.plateNO];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.carsArray.count == 0) {
        return nil;
    }
    NSString *typeString;
    if (tableView == self.tableView) {
        if (section == 0) {
            typeString = @"choiceCar";
        }
        XDDelockingHeadView *head = [XDDelockingHeadView headerViewWithTableView:tableView withType:typeString];
        head.carNumLabel.text = self.carModel.plateNO;
        [head.popBtn addTarget:self action:@selector(headBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return head;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.popTableView) {
        XDVehicleModel *carModel = self.carsArray[indexPath.row];
        if (self.carModel.plateNO == carModel.plateNO) {
            [self.popView dissPopoverViewWithAnimation:YES];
            return;
        }
        self.carModel = self.carsArray[indexPath.row];
        [self getAlarmCars];
        [self.popView dissPopoverViewWithAnimation:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            return 67;
        }
        return 108;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.carsArray.count == 0) {
        return 0.001;
    }
    if (tableView == self.tableView) {
        if (section == 0) {
            return 38;
        } else {
            return 33;
        }
    }
    return 0.001;
}

#pragma mark -- action
- (void)headBtnClicked:(UIButton *)sender {
    XDDelockingHeadView *cell = (XDDelockingHeadView *)[self.tableView headerViewForSection:0];
    CGRect rect = [cell.backViews convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    [self setUpPopView:sender];
    [self.popView showPopoverWithRect:rect animation:YES];
}

// 插入popView
- (void)setUpPopView:(UIButton *)sender {
    _popTableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , 0,  sender.width, 79)];
    _popTableView.delegate = self;
    _popTableView.dataSource = self;
    _popTableView.tag = 3;
    _popTableView.rowHeight = 40;
    _popTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _popTableView.backgroundColor = [UIColor whiteColor];
    
    self.popView = [[GSPopoverViewController alloc]initWithShowView:self.popTableView];
    self.popView.borderWidth = 1;
    self.popView.borderColor = BianKuang;
}

- (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    alertView.delegate = self;
    [window addSubview:alertView];
}

- (void)clickButtonWithTag:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy load
- (NSMutableArray *)carsArray {
    if (!_carsArray) {
        _carsArray = [[NSMutableArray alloc] init];
    }
    return _carsArray;
}

- (NSMutableArray *)carsRecordArray {
    if (!_carsRecordArray) {
        _carsRecordArray = [NSMutableArray array];
    }
    return _carsRecordArray;
}

@end
