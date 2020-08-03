//
//  Created by cfsc on 2020/3/19.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDFlowListController.h"
#import "XDFlowListCell.h"
#import "XDFlowModel.h"
#import "XDFlowDetailController.h"
#import "FilterSlideDataViewController.h"

@interface XDFlowListController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *flowArray;
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, copy) NSDictionary *filterParams;

@end

@implementation XDFlowListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(230, 230, 230);
    self.pageNo = 1;
    // 配置tableView
    [self setUpTableView];
    [self.tableView.mj_header beginRefreshing];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_filter" frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(filterAciton)];
}

- (void)filterAciton {
    BaseNavigationController *baseNav = (BaseNavigationController *)self.navigationController;
    baseNav.barStyle = UIStatusBarStyleDefault;
    FilterSlideDataViewController *filterVC = [[FilterSlideDataViewController alloc] init];
    filterVC.flowType = self.flowType;
    for (NSString *key in self.filterParams.allKeys) {
        HZSingleChoiceModel *model = self.filterParams[key];
        if ([key isEqualToString:@"isFinish"]) {
            filterVC.completeStatusChoice = model;
        } else if ([key isEqualToString:@"statusId"]) {
            filterVC.flowStatusChoice = model;
        } else if ([key isEqualToString:@"typeId"]) {
            filterVC.typeChoice = model;
        }
    }
    CGRect rect  = [UIScreen mainScreen].bounds;
    filterVC.view.frame = rect;
    [[UIApplication sharedApplication].keyWindow addSubview:filterVC.view];
    [filterVC showHideSidebar];
    [self addChildViewController:filterVC];
    __weak typeof(self) weakSelf = self;
    filterVC.backBlock = ^(NSDictionary *backData){
        baseNav.barStyle = UIStatusBarStyleLightContent;
        weakSelf.filterParams = backData;
        [weakSelf getFlowList];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView.mj_header beginRefreshing];
}

- (void)setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"XDFlowListCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDFlowListCell"];
    [self.tableView addSubview:self.noDataView];
    
    SEL headSel = nil;
    SEL footSel = nil;
    if (self.flowStatus == XDFlowStatusAll) {
        if (self.flowType == XDFlowTypeOrder) {
            self.title = @"我的工单";
        } else if (self.flowType == XDFlowTypeComplain) {
            self.title = @"我的投诉";
        }
        headSel = NSSelectorFromString(@"getFlowList");
        footSel = NSSelectorFromString(@"loadMoreFlowData");
    } else {
        return;
    }
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:headSel];
    header.lastUpdatedTimeLabel.hidden = NO;
    self.tableView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:footSel];
    self.tableView.mj_footer = footer;
}

#pragma mark - Load Data
- (void)getFlowList {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@(self.pageNo) forKey:@"pageNo"];
    [dic setValue:@(PageSiz) forKey:@"pageSize"];
    [dic setValue:@(self.flowType) forKey:@"type"];
    [dic setValue:loginInfo.userModel.userID forKey:@"userId"];
    [dic setValue:@1 forKey:@"userType"];
    [dic setValue:loginInfo.userModel.currentDistrict.projectId forKey:@"projectId"];
    for (NSString *key in self.filterParams.allKeys) {
        HZSingleChoiceModel *model = self.filterParams[key];
        if (model.typeCode.intValue != 99) {
            [dic setValue:model.typeCode forKey:key];
        }
    }
    WEAKSELF
    [XDHTTPRequst getFlowListWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.flowArray removeAllObjects];
            NSArray *dataArray = res[@"result"][@"data"];
            for (NSDictionary *dic in dataArray) {
                XDFlowModel *flow = [XDFlowModel mj_objectWithKeyValues:dic];
                [weakSelf.flowArray addObject:flow];
            }
            [weakSelf.tableView reloadData];
            if (dataArray.count < PageSiz) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [MBProgressHUD hideHUD];
        [weakSelf.tableView.mj_header endRefreshing];
    } fail:^(NSError *error) {
        [XDHTTPRequst showErrorMessageWith:error];
        [MBProgressHUD hideHUD];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreFlowData {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    self.pageNo += 1;
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@(self.pageNo) forKey:@"pageNo"];
    [dic setValue:@(PageSiz) forKey:@"pageSize"];
    [dic setValue:@(self.flowType) forKey:@"type"];
    [dic setValue:loginInfo.userModel.userID forKey:@"userId"];
    [dic setValue:@1 forKey:@"userType"];
    [dic setValue:loginInfo.userModel.currentDistrict.projectId forKey:@"projectId"];
    for (NSString *key in self.filterParams.allKeys) {
        HZSingleChoiceModel *model = self.filterParams[key];
        [dic setValue:model.typeCode forKey:key];
    }
    WEAKSELF
    [XDHTTPRequst getFlowListWithDic:dic succeed:^(id res) {
        [MBProgressHUD hideHUD];
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([res[@"code"] integerValue] == 200) {
            NSArray *dataArray = res[@"result"][@"data"];
            for (NSDictionary *dic in dataArray) {
                XDFlowModel *flow = [XDFlowModel mj_objectWithKeyValues:dic];
                [weakSelf.flowArray addObject:flow];
            }
            [weakSelf.tableView reloadData];
            if (dataArray.count < PageSiz) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            weakSelf.pageNo -= 1;
        }
    } fail:^(NSError *error) {
        NSLog(@"loadMoreFlowData---%@", error);
        [MBProgressHUD hideHUD];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.pageNo -= 1;
    }];
}

#pragma mark - table view data source & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.flowArray.count == 0) {
        self.noDataView.hidden = NO;
    } else {
        self.noDataView.hidden = YES;
    }
    return self.flowArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 178;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDFlowModel *flow = self.flowArray[indexPath.row];
    XDFlowListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDFlowListCell"];
    [cell setContentWithFlowModel:flow];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDFlowModel *flow = self.flowArray[indexPath.row];
    XDFlowDetailController *detailVC = [[XDFlowDetailController alloc] init];
    detailVC.flow = flow;
    detailVC.flowType = self.flowType;
    detailVC.didUpdateFlowNode = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray *)flowArray {
    if (!_flowArray) {
        _flowArray = [[NSMutableArray alloc] init];
    }
    return _flowArray;
}

- (UIView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        _noDataView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, self.tableView.bounds.size.width, 40)];
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"没有数据";
        label.textColor = RGB(78, 78, 78);
        label.textAlignment = NSTextAlignmentCenter;
        [_noDataView addSubview:label];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}

@end
