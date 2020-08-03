//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDUnitSelectController.h"
#import "XDHouseTreeModel.h"
#import "XDRoomSelectController.h"

@interface XDUnitSelectController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) XDLoginInfoModel *loginInfo;

@end

@implementation XDUnitSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.loginInfo = [XDArchiverManager loginInfo];
    [self loadData];
}

- (void)loadData {
    WEAKSELF
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst getHouseCongfigTreeSucceed:^(NSDictionary *res) {
        if ([res[@"code"] integerValue] == 200) {
            XDHouseTreeModel *model = [XDHouseTreeModel mj_objectWithKeyValues:res];
            for (XDHouseConfigModel *configModel in model.result) {
                if ([configModel.key isEqualToString:self.loginInfo.userModel.currentDistrict.projectId]) {
                    [weakSelf resetPhaseArray:configModel.children];
                }
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

- (void)resetPhaseArray:(NSArray *)phaseArray {
    WEAKSELF
    for (XDHouseConfigModel *phaseChild in phaseArray) {
        NSMutableArray *buildingArray = [[NSMutableArray alloc] init];
        for (XDHouseConfigModel *buildingChild in phaseChild.children) {
            for (XDHouseConfigModel *unitChild in buildingChild.children) {
                unitChild.title = [NSString stringWithFormat:@"%@%@%@%@", weakSelf.loginInfo.userModel.currentDistrict.projectName, phaseChild.title, buildingChild.title, unitChild.title];
                [buildingArray addObject:unitChild];
            }
        }
        phaseChild.children = buildingArray;
        [weakSelf.itemArray addObject:phaseChild];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XDHouseConfigModel *model = self.itemArray[section];
    return model.children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDHouseConfigModel *model = self.itemArray[indexPath.section];
    XDHouseConfigModel *configModel = model.children[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor = RGB(79, 79, 79);
    cell.textLabel.text = [NSString stringWithFormat:@"%@", configModel.title];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XDHouseConfigModel *model = self.itemArray[section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = litterBackColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 30)];
    label.text = [NSString stringWithFormat:@"%@%@", self.loginInfo.userModel.currentDistrict.projectName, model.title];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor lightGrayColor];
    [headerView addSubview:label];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDHouseConfigModel *model = self.itemArray[indexPath.section];
    XDHouseConfigModel *configModel = model.children[indexPath.row];
    XDRoomSelectController *roomSelVC = [[XDRoomSelectController alloc] init];
    roomSelVC.unitID = configModel.key;
    roomSelVC.unitName = configModel.title;
    [self.navigationController pushViewController:roomSelVC animated:YES];
}

- (NSMutableArray<XDHouseConfigModel *> *)itemArray {
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}

@end
