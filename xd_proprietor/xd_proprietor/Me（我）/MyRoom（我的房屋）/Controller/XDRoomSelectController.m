//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDRoomSelectController.h"
#import "XDRoomModel.h"
#import "XDRoomIdentifySelectController.h"

@interface XDRoomSelectController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <XDRoomModel *>*itemArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XDRoomSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configTableView];
    [self loadRoomData];
}

- (void)configTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRoomData)];
    self.tableView.mj_footer = footer;
//    footer.hidden = YES;
}

- (void)loadRoomData {
    self.currentPage = 1;
    WEAKSELF
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst getRoomListWithUnitID:self.unitID pageNo:self.currentPage succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            NSArray *roomArray = res[@"result"][@"data"];
            for (NSDictionary *dic in roomArray) {
                XDRoomModel *model = [XDRoomModel mj_objectWithKeyValues:dic];
                [weakSelf.itemArray addObject:model];
            }
            [weakSelf.tableView reloadData];
            if (roomArray.count < PageSiz) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                weakSelf.tableView.mj_footer.hidden = YES;
            } else {
//                weakSelf.tableView.mj_footer.hidden = NO;
            }
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

- (void)loadMoreRoomData {
    WEAKSELF
    self.currentPage += 1;
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst getRoomListWithUnitID:self.unitID pageNo:self.currentPage succeed:^(id res) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([res[@"code"] integerValue] == 200) {
            NSArray *roomArray = res[@"result"][@"data"];
            for (NSDictionary *dic in roomArray) {
                XDRoomModel *model = [XDRoomModel mj_objectWithKeyValues:dic];
                [weakSelf.itemArray addObject:model];
            }
            [weakSelf.tableView reloadData];
            if (roomArray.count < PageSiz) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [MBProgressHUD hideHUD];
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

#pragma mark - tableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDRoomModel *model = self.itemArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor = RGB(79, 79, 79);
    cell.textLabel.text = model.name;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = litterBackColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 30)];
    label.text = self.unitName;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor lightGrayColor];
    [headerView addSubview:label];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDRoomModel *model = self.itemArray[indexPath.row];
    XDRoomIdentifySelectController *roomIdentifyVC = [[XDRoomIdentifySelectController alloc] init];
    roomIdentifyVC.roomModel = model;
    [self.navigationController pushViewController:roomIdentifyVC animated:YES];
}

- (NSMutableArray<XDRoomModel *> *)itemArray {
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}

@end
