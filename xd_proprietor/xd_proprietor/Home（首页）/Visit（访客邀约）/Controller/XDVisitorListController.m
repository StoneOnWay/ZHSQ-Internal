//
//  Created by cfsc on 2020/2/5.
//  Copyright © 2020年 cfsc. All rights reserved.
//

#import "XDVisitorListController.h"
#import "XDVisitListCell.h"
#import "XDNewVisitController.h"
#import "XDVisitDetailController.h"

#define TABLEVIEW_TOP_INSET 15

@interface XDVisitorListController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listModelArray;
@property (nonatomic, assign) int currentPage;
@end

@implementation XDVisitorListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"访客邀约";
    [self prepareVisitTableView];
    [self getVisitList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoticeAction) name:@"refreshVisitList" object:nil];
}

- (void)getNoticeAction {
    if (self.listModelArray.count != 0) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    [self getVisitList];
}

- (void)prepareVisitTableView {
    self.tableView.contentInset = UIEdgeInsetsMake(TABLEVIEW_TOP_INSET, 0, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 0.0f;
    self.tableView.backgroundColor = litterBackColor;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = litterBackColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XDVisitListCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDVisitListCell"];
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getVisitList)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *Footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreVisitList)];
    self.tableView.mj_footer = Footer;
}

- (void)getVisitList {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *phaseId = loginInfo.userModel.currentDistrict.phaseId;
    if (!phaseId) {
        [MBProgressHUD showTipMessageInView:@"当前登录用户信息错误！" timer:2];
        return;
    }
    self.currentPage = 1;
    NSDictionary *dic = @{
                          @"phaseId":phaseId,
                          @"pageNo":@(self.currentPage),
                          @"pageSize":@(PageSiz)
                          };
    [self.tableView.mj_footer resetNoMoreData];
    [MBProgressHUD showActivityMessageInView:nil];
    WEAKSELF
    [XDHTTPRequst getVisitListWithDic:dic succeed:^(id res) {
        [self.tableView.mj_header endRefreshing];
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.listModelArray removeAllObjects];
            for (NSDictionary *dic in res[@"result"][@"data"]) {
                XDVisitorModel *model = [XDVisitorModel mj_objectWithKeyValues:dic];
                [weakSelf dealModelEffective:model];
                [weakSelf.listModelArray addObject:model];
            }
            if ([res[@"result"][@"data"] count] < PageSiz) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [MBProgressHUD hideHUD];
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)loadMoreVisitList {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *phaseId = loginInfo.userModel.currentDistrict.phaseId;
    if (!phaseId) {
        [MBProgressHUD showTipMessageInView:@"当前登录用户信息错误！" timer:2];
        return;
    }
    self.currentPage += 1;
    NSDictionary *dic = @{
                          @"phaseId":phaseId,
                          @"pageNo":@(self.currentPage),
                          @"pageSize":@(PageSiz)
                          };
    [MBProgressHUD showActivityMessageInView:nil];
    WEAKSELF
    [XDHTTPRequst getVisitListWithDic:dic succeed:^(id res) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([res[@"code"] integerValue] == 200) {
            for (NSDictionary *dic in res[@"result"][@"data"]) {
                XDVisitorModel *model = [XDVisitorModel mj_objectWithKeyValues:dic];
                [weakSelf dealModelEffective:model];
                [weakSelf.listModelArray addObject:model];
            }
            if ([res[@"result"][@"data"] count] < PageSiz) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [MBProgressHUD hideHUD];
            [weakSelf.tableView reloadData];
        } else {
            weakSelf.currentPage -= 1;
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        weakSelf.currentPage -= 1;
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (IBAction)visitAciton:(id)sender {
    XDNewVisitController *newVisit = [[XDNewVisitController alloc] init];
    [self.navigationController pushViewController:newVisit animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDVisitListCell *cell = [XDVisitListCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    XDVisitorModel *model = self.listModelArray[indexPath.row];
    cell.nameLabels.text = model.visitorName;
    cell.timeLabels.text = [NSString stringWithFormat:@"有效期：%@",model.expireTime];
    if ([model.iseffective isEqualToString:@"1"]) {
        cell.isOutUse.text = @"有效";
    } else {
        cell.isOutUse.text = @"已作废";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XDVisitDetailController *detail = [[XDVisitDetailController alloc] init];
    XDVisitorModel *model = self.listModelArray[indexPath.row];
    detail.visitModel = model;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)dealModelEffective:(XDVisitorModel *)model {
    NSDate *date = [NSDate dateWithString:model.expireTime format:VISIT_DATE_FORMATTER];
    NSTimeInterval t1 = [date timeIntervalSince1970];
    NSTimeInterval t2 = [[NSDate date] timeIntervalSince1970];
    if (t1 > t2) {
        model.iseffective = @"1";
    } else {
        model.iseffective = @"0";
    }
}

- (NSMutableArray *)listModelArray {
    if (!_listModelArray) {
        self.listModelArray = [NSMutableArray array];
    }
    return _listModelArray;
}

@end
