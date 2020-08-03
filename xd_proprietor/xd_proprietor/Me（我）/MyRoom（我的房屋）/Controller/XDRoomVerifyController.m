//
//  Created by cfsc on 2020/4/15.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDRoomVerifyController.h"
#import "XDRoomVerifyCell.h"

@interface XDRoomVerifyController () {
    UILabel *footerLabel;
}
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation XDRoomVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房屋审核";
    [self.tableView registerNib:[UINib nibWithNibName:@"XDRoomVerifyCell" bundle:nil] forCellReuseIdentifier:@"XDRoomVerifyCell"];
    self.tableView.backgroundColor = litterBackColor;
    footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    footerLabel.font = [UIFont systemFontOfSize:14];
    footerLabel.textColor = RGB(88, 88, 88);
    footerLabel.text = @"无房屋审核记录";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView.tableFooterView addSubview:footerLabel];
    self.tableView.tableFooterView = footerLabel;
    footerLabel.hidden = YES;
    [self loadVerifyData];
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}

- (void)loadVerifyData {
    [MBProgressHUD showActivityMessageInView:nil];
    WEAKSELF
    [XDHTTPRequst getAllVerifyListWithRoomId:self.roomModel.roomId succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.itemArray removeAllObjects];
            for (NSDictionary *dic in res[@"result"][@"data"]) {
                XDVerifyModel *verifyModel = [XDVerifyModel mj_objectWithKeyValues:dic];
                [weakSelf.itemArray addObject:verifyModel];
                [weakSelf.tableView reloadData];
            }
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.itemArray.count == 0) {
        footerLabel.hidden = NO;
    } else {
        footerLabel.hidden = YES;
    }
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDVerifyModel *model = self.itemArray[indexPath.row];
    XDRoomVerifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDRoomVerifyCell" forIndexPath:indexPath];
    cell.verifyModel = model;
    @weakify(self);
    cell.verifyCompleted = ^{
        @strongify(self);
        [self loadVerifyData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}

@end
