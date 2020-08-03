//
//  XDInformNewsListController.m
//  XD业主
//
//  Created by zc on 2017/6/24.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDInformNewsListController.h"
#import "XDInformNewsListCell.h"
#import "XDInfoNewDetailNetController.h"
#import "XDContentInfoModel.h"
#import "XDCommonBusiness.h"

@interface XDInformNewsListController () {
    NSString *projectID;
}

@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, strong) XDLoginInfoModel *loginInfo;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XDInformNewsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = backColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loginInfo = [XDArchiverManager loginInfo];
    projectID = self.loginInfo.userModel.currentDistrict.projectId;
    // 请求数据
    if ([self.title isEqualToString:@"通知公告"]) {
        // 添加刷新控件
        [self prepareTableViewRefresh];
        [self loadNewsData];
    } else if ([self.title isEqualToString:@"入伙"]) {
        [self loadDataWithID:joinTypeID];
    } else if ([self.title isEqualToString:@"工程进度"]) {
        [self loadDataWithID:workProgressTypeID];
    }
}

// 准备刷新控件--tableView
- (void)prepareTableViewRefresh {
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewsData)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
    MJRefreshAutoNormalFooter *Footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNewsData)];
    self.tableView.mj_footer = Footer;
    [self.tableView.mj_footer endRefreshing];
}

// 加载通知公告数据
- (void)loadNewsData {
    self.currentPage = 1;
    [self.infoArray removeAllObjects];
    [self.tableView.mj_footer resetNoMoreData];
    if (!projectID) {
        return;
    }
    WEAKSELF
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
                          @"pageNo":[NSNumber numberWithInteger:self.currentPage],
                          @"pageSize":@(PageSiz),
                          @"announcementTypeId":newsTypeID,
                          @"projectId":projectID,
                          @"auditStatus":@1,
                          @"pushStatus":@1,
                          @"receiver":[[XDCommonBusiness shareInstance] getCurrentUserType]
                          };
    [XDHTTPRequst getContentListWithDic:dic succeed:^(id res) {
        [weakSelf.tableView.mj_header endRefreshing];
        if ([res[@"code"] integerValue] == 200) {
            NSArray *array = res[@"result"][@"data"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                XDContentInfoModel *model = [XDContentInfoModel mj_objectWithKeyValues:dic];
                [weakSelf.infoArray addObject:model];
            }
            if (weakSelf.infoArray.count < PageSiz) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 上拉加载更多通知公告
- (void)loadMoreNewsData {
    self.currentPage += 1;
    if (!projectID) {
        return;
    }
    WEAKSELF
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
                          @"pageNo":[NSNumber numberWithInteger:self.currentPage],
                          @"pageSize":@(PageSiz),
                          @"announcementTypeId":newsTypeID,
                          @"projectId":projectID,
                          @"auditStatus":@1,
                          @"pushStatus":@1,
                          @"receiver":[[XDCommonBusiness shareInstance] getCurrentUserType]
                          };
    [XDHTTPRequst getContentListWithDic:dic succeed:^(id res) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([res[@"code"] integerValue] == 200) {
            NSArray *array = res[@"result"][@"data"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                XDContentInfoModel *model = [XDContentInfoModel mj_objectWithKeyValues:dic];
                [weakSelf.infoArray addObject:model];
            }
            if (weakSelf.infoArray.count < PageSiz) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUD];
        } else {
            weakSelf.currentPage -= 1;
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.currentPage -= 1;
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 根据类型加载数据
- (void)loadDataWithID:(NSString *)dataTypeID {
    if (!projectID) {
        return;
    }
    WEAKSELF
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@(PageSiz),
                          @"announcementTypeId":dataTypeID,
                          @"projectId":projectID,
                          @"auditStatus":@1,
                          @"pushStatus":@1,
                          @"receiver":[[XDCommonBusiness shareInstance] getCurrentUserType]
                          };
    [XDHTTPRequst getContentListWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            NSArray *array = res[@"result"][@"data"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                XDContentInfoModel *model = [XDContentInfoModel mj_objectWithKeyValues:dic];
                [weakSelf.infoArray addObject:model];
            }
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDInformNewsListCell *cell = [XDInformNewsListCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XDContentInfoModel *model = self.infoArray[indexPath.row];
    cell.titleLabels.text = model.title;
    cell.detailLabels.text = model.summary;
    cell.iconImageUrl = model.coverUrl;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDInfoNewDetailNetController *info = [[XDInfoNewDetailNetController alloc] init];
    XDContentInfoModel *model = self.infoArray[indexPath.row];
    info.infoModel = model;
    [self.navigationController pushViewController:info animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        self.infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

@end
