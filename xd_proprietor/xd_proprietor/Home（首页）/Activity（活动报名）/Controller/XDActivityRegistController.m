//
//  Created by cfsc on 2020/6/29.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDActivityRegistController.h"
#import "HZBaseListInfoTableViewCell.h"
#import "XDFlowOperationBtnView.h"

@interface XDActivityRegistController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation XDActivityRegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动报名";
    [self configTableView];
    [self configDataSource];
}

- (void)configTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavHeight)];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = UIColorHex(f3f3f3);
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HZBaseListInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HZBaseListInfoTableViewCell class])];
    tableView.tableFooterView = [[UIView alloc] init];
    UITapGestureRecognizer *tapTableView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableViewAction)];
    tapTableView.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapTableView];
    
    XDFlowOperationBtnView *operationBtn = [XDFlowOperationBtnView loadFromNib];
    operationBtn.frame = CGRectMake(0, 0, kScreenWidth, 102.f);
    [operationBtn setOperationBtnType:XDFlowOperationBtnTypeSingle];
    [operationBtn setSingleBtnTitle:@"提交"];
    operationBtn.backgroundColor = UIColorHex(f3f3f3);
    @weakify(self);
    [operationBtn setClickOperationBlock:^(XDClickType clickType) {
        @strongify(self);
        [self signUpActivity];
    }];
    self.tableView.tableFooterView = operationBtn;
}

- (void)tapTableViewAction {
    [self.view endEditing:YES];
}

- (void)configDataSource {
    [self.itemArray removeAllObjects];
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    HZBaseModel *nameModel = [[HZBaseModel alloc] init];
    nameModel.title = @"姓    名：";
    nameModel.baseType = HZBaseTypeTextField;
    nameModel.value = loginInfo.userModel.name;
    [self.params setValue:nameModel.value forKey:@"name"];
    [self.itemArray addObject:nameModel];
    HZBaseModel *genderModel = [[HZBaseModel alloc] init];
    genderModel.title = @"性    别：";
    genderModel.baseType = HZBaseTypeTextWithArrow;
    genderModel.value = @"男";
    [self.params setValue:genderModel.value forKey:@"gender"];
    [self.itemArray addObject:genderModel];
    HZBaseModel *ageModel = [[HZBaseModel alloc] init];
    ageModel.title = @"年    龄：";
    ageModel.baseType = HZBaseTypeTextField;
    ageModel.value = @"18";
    [self.params setValue:ageModel.value forKey:@"age"];
    [self.itemArray addObject:ageModel];
    HZBaseModel *phoneModel = [[HZBaseModel alloc] init];
    phoneModel.title = @"电    话：";
    phoneModel.baseType = HZBaseTypeTextField;
    phoneModel.value = loginInfo.userModel.mobile;
    [self.params setValue:phoneModel.value forKey:@"mobile"];
    [self.itemArray addObject:phoneModel];
}

- (NSString *)keyChange:(NSString *)key {
    NSDictionary *dic = @{
        @"姓    名：" : @"name",
        @"性    别：" : @"gender",
        @"年    龄：" : @"age",
        @"电    话：" : @"mobile"
    };
    return dic[key];
}

- (void)signUpActivity {
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst registActivityParticipatorWithDic:self.params succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XDActivityDidUpdateRegistNoti object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"]];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HZBaseModel *baseModel = self.itemArray[indexPath.row];
    HZBaseListInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZBaseListInfoTableViewCell class]) forIndexPath:indexPath];
    cell.baseModel = baseModel;
    @weakify(self)
    [cell setInputContentChangeBlock:^(NSString *content) {
        @strongify(self)
        baseModel.value = content;
        [self.params setValue:content forKey:[self keyChange:baseModel.title]];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
    label.text = @"编辑报名信息";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    [headerView addSubview:label];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HZBaseModel *model = self.itemArray[indexPath.row];
    if (model.baseType == HZBaseTypeTextWithArrow && [model.title isEqualToString:@"性    别："]) {
        [self alterSexPortrait:model];
    }
}

// 选择性别弹出框
- (void)alterSexPortrait:(HZBaseModel *)model {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        model.value = @"男";
        [self.params setValue:@"男" forKey:@"gender"];
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        model.value = @"女";
        [self.params setValue:@"女" forKey:@"gender"];
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - lazyLoad
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
        XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
        [self.params setValue:loginInfo.userModel.userID forKey:@"householdId"];
        [self.params setValue:self.activity.eventId forKey:@"eventId"];
        [self.params setValue:self.activity.eventId forKey:@"name"];
        [self.params setValue:self.activity.eventId forKey:@"eventId"];
        [self.params setValue:self.activity.eventId forKey:@"eventId"];
        [self.params setValue:self.activity.eventId forKey:@"eventId"];
    }
    return _params;
}

@end
