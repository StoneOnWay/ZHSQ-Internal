//
//  Created by cfsc on 2020/6/18.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDRemoteOpenController.h"
#import "XDRemoteOpenTableCell.h"

@interface XDRemoteOpenController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *equipmentList;

@end

@implementation XDRemoteOpenController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self getEquipmentList];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)configTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDRemoteOpenTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDRemoteOpenTableCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)getEquipmentList {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (!loginInfo.userModel.userID || !loginInfo.userModel.currentDistrict.phaseId) {
        return;
    }
    NSDictionary *dic = @{
        @"userId":loginInfo.userModel.userID,
        @"phaseId":loginInfo.userModel.currentDistrict.phaseId
    };
    // MBProgressHUD提供的方法显示不出来
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"";
    hud.label.font=[UIFont systemFontOfSize:14];
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    WEAKSELF
    [XDHTTPRequst getEquipmentListWithDic:dic succeed:^(id res) {
        [hud hideAnimated:YES];
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.equipmentList removeAllObjects];
            for (NSDictionary *dic in res[@"result"]) {
                XDEquipmentModel *equip = [XDEquipmentModel mj_objectWithKeyValues:dic];
                [weakSelf.equipmentList addObject:equip];
            }
            [weakSelf.tableView reloadData];
        } else {
            [XDUtil showToast:res[@"message"]];
        }
    } fail:^(NSError *error) {
        [hud hideAnimated:YES];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.equipmentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDEquipmentModel *model = self.equipmentList[indexPath.row];
    XDRemoteOpenTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDRemoteOpenTableCell" forIndexPath:indexPath];
    cell.equipment = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (IBAction)cancleAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)equipmentList {
    if (!_equipmentList) {
        _equipmentList = [[NSMutableArray alloc] init];
    }
    return _equipmentList;
}

@end
