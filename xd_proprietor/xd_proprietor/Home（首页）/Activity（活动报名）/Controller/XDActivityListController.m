//
//  Created by cfsc on 2020/6/15.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDActivityListController.h"
#import "XDActivityTableCell.h"
#import "XDActivityModel.h"
#import "XDActivityDetailController.h"

@interface XDActivityListController ()
@property (strong, nonatomic) NSMutableArray *activityArr;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) UILabel *footerLabel;
@end

@implementation XDActivityListController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self = [super initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区活动";
    [self configTableView];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"我参加的" forState:(UIControlStateNormal)];
    [button setTitle:@"全部活动" forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(filterData:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 80, 40);
    [rightView addSubview:button];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:XDActivityDidUpdateRegistNoti object:nil];
    [self getActivityData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XDActivityDidUpdateRegistNoti object:nil];
}

- (void)updateData {
    [self getActivityData];
}

- (void)filterData:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self.params setValue:@1 forKey:@"isParticipate"];
    } else {
        [self.params setValue:nil forKey:@"isParticipate"];
    }
    [self getActivityData];
}

- (void)configTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDActivityTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDActivityTableCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getActivityData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    self.footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    self.footerLabel.font = [UIFont systemFontOfSize:14];
    self.footerLabel.textColor = RGB(88, 88, 88);
    self.footerLabel.text = @"当前无已参加的活动";
    self.footerLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = self.footerLabel;
    self.footerLabel.hidden = YES;
}

- (void)getActivityData {
    WEAKSELF
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst getActivityListWithDic:self.params succeed:^(id res) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.activityArr removeAllObjects];
            NSArray *array = res[@"result"][@"data"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                XDActivityModel *model = [XDActivityModel mj_objectWithKeyValues:dic];
                [self dealModelEffective:model];
                [weakSelf.activityArr addObject:model];
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 判断是否已经结束
- (void)dealModelEffective:(XDActivityModel *)model {
    NSDate *date = [NSDate dateWithString:model.registrationDeadline format:@"yyyy-MM-dd"];
    NSTimeInterval t1 = [date timeIntervalSince1970];
    NSTimeInterval t2 = [[NSDate date] timeIntervalSince1970];
    if (t1 > t2) {
        model.isEnd = @"0";
    } else {
        model.isEnd = @"1";
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.activityArr.count == 0) {
        self.footerLabel.hidden = NO;
        self.footerLabel.frame = CGRectMake(0, 0, kScreenWidth, 60);
    } else {
        self.footerLabel.hidden = YES;
        self.footerLabel.frame = CGRectMake(0, 0, kScreenWidth, 0);
    }
    return self.activityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDActivityModel *model = self.activityArr[indexPath.row];
    XDActivityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDActivityTableCell" forIndexPath:indexPath];
    cell.activity = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat imageHeight = 105.f * (kScreenWidth - 30) / (414 - 30);
    return imageHeight + 155.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 50)];
    label.text = @"社区活动";
    label.font = [UIFont systemFontOfSize:22];
    label.textColor = [UIColor blackColor];
    [headerView addSubview:label];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDActivityModel *model = self.activityArr[indexPath.row];
    XDActivityDetailController *detailVC = [[XDActivityDetailController alloc] init];
    detailVC.activity = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray *)activityArr {
    if (!_activityArr) {
        _activityArr = [NSMutableArray array];
    }
    return _activityArr;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
        _params = [[NSMutableDictionary alloc] init];
        [_params setValue:@1 forKey:@"pageNo"];
        [_params setValue:@100 forKey:@"pageSize"];
        [_params setValue:loginInfo.userModel.currentDistrict.projectId forKey:@"projectId"];
        [_params setValue:@0 forKey:@"isClosed"];
    }
    return _params;
}

@end
