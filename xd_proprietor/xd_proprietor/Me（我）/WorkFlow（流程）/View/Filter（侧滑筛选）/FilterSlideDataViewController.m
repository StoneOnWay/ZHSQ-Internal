//
//  FilterSlideViewController.m
//  Vasse
//
//  Created by 饶首建 on 16/5/19.
//  Copyright © 2016年 voossi. All rights reserved.
//

#import "FilterSlideDataViewController.h"
#import "InfoTableViewCell.h"
#import "DetailInfoTableViewCell.h"

@interface FilterSlideDataViewController () <UITableViewDelegate, UITableViewDataSource> {
    CGRect _frame;
    UIButton *_sureBtn;
    UIButton *_resetBtn;
    UIButton *_backBtn;
    NSArray *_firstArray;
    
    NSArray *_otherTableDatasource;
    NSInteger _otherTableDataType;
    
    HZSingleChoiceModel *_choosedProvince;
    HZSingleChoiceModel *_choosedCity;
}

@property (nonatomic, strong) UITableView *menuTableView; // 一级页面Table
@property (nonatomic, strong) UIView *otherContainerView; // 二级页面容器
@property (nonatomic, strong) UITableView *otherTableView; // 二级页面Table，显示省、市
@property (nonatomic, strong) NSMutableArray *completeStatusArr; // 完成状态
@property (nonatomic, strong) NSMutableArray *typeArr; // 类型
@property (nonatomic, strong) NSMutableArray *flowStatusArr; // 流程状态

@end

@implementation FilterSlideDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)initView{
#pragma mark 一级页面
    CGRect wsframe = self.contentView.bounds;
    wsframe.origin.y = 20;
    wsframe.size.height = wsframe.size.height - 64;
    self.menuTableView = [[UITableView alloc] initWithFrame:wsframe style:UITableViewStyleGrouped];
    self.menuTableView.backgroundColor = [UIColor whiteColor];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.showsVerticalScrollIndicator = NO;
    self.menuTableView.tableFooterView = [[UIView alloc] init];
    [self.contentView addSubview:self.menuTableView];
    // 线
    UIView *btnLine = [[UIView alloc]initWithFrame:CGRectMake(0, kSBHeight-64, self.contentView.bounds.size.width, 0.5)];
    btnLine.backgroundColor = BianKuang;
    [self.contentView addSubview:btnLine];
    // 重置
    _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resetBtn.frame = CGRectMake(20, kSBHeight - 64 + 12, kSidebarWidth*0.5-30, 40);
    _resetBtn.backgroundColor = [UIColor whiteColor];
    _resetBtn.layer.cornerRadius = 20.f;
    _resetBtn.layer.masksToBounds = YES;
    _resetBtn.layer.borderColor = BianKuang.CGColor;
    _resetBtn.layer.borderWidth = 1.f;
    [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    _resetBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_resetBtn];
    // 确定
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(kSidebarWidth*0.5+10, kSBHeight - 64 + 12, kSidebarWidth*0.5-30, 40);
    _sureBtn.backgroundColor = RGB(220, 55, 38);
    _sureBtn.layer.cornerRadius = 20;
    _sureBtn.layer.masksToBounds = YES;
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_sureBtn];
    
    // 二级页面
#pragma mark 二级页面
    _frame = self.contentView.bounds;
    _frame.origin.y = 0;
    _frame.origin.x = _frame.size.width;
    
    _otherContainerView = [[UIView alloc]initWithFrame:_frame];
    _otherContainerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_otherContainerView];
    // 返回
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10, NavHeight - 40, 50, 40);
//    _backBtn.backgroundColor = [UIColor greenColor];
    [_backBtn setImage:[UIImage imageNamed:@"icon_Back Chevron"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_otherContainerView addSubview:_backBtn];
    // 线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight-0.5, self.contentView.bounds.size.width, 0.5)];
    line.backgroundColor = BianKuang;
    [_otherContainerView addSubview:line];
    
    _otherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, _frame.size.width, _frame.size.height-64)];
    [_otherTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _otherTableView.showsVerticalScrollIndicator = NO;
    _otherTableView.delegate = self;
    _otherTableView.dataSource = self;
    self.otherTableView.tableFooterView = [[UIView alloc] init];
    [_otherContainerView addSubview:_otherTableView];
    
    // 添加右滑监测
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [panGesture delaysTouchesBegan];
    [self.view addGestureRecognizer:panGesture];
}

- (void)initData {
    HZSingleChoiceModel *model1 = [[HZSingleChoiceModel alloc] init];
    model1.title = @"全部";
    model1.typeCode = @"99";
    [self.completeStatusArr addObject:model1];
    HZSingleChoiceModel *model2 = [[HZSingleChoiceModel alloc] init];
    model2.title = @"未完成";
    model2.typeCode = @"0";
    [self.completeStatusArr addObject:model2];
    HZSingleChoiceModel *model3 = [[HZSingleChoiceModel alloc] init];
    model3.title = @"已完成";
    model3.typeCode = @"1";
    [self.completeStatusArr addObject:model3];
    
    if (self.flowType == XDFlowTypeOrder) {
        _firstArray = @[@"工单完成状态", @"工单类型", @"工单状态"];
        [self getOrderTypeList];
        [self getOrderStatusList];
    } else if (self.flowType == XDFlowTypeComplain) {
        _firstArray = @[@"投诉完成状态", @"投诉类型", @"投诉状态"];
        [self getComplainTypeList];
        [self getComplainStatusList];
    }
    [_menuTableView reloadData];
}

// 获取工单类型列表
- (void)getOrderTypeList {
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@100
                          };
    @weakify(self);
    [XDHTTPRequst getOrderTypeListWithDic:dic succeed:^(id res) {
        @strongify(self);
        if ([res[@"code"] integerValue] == 200) {
            [self.typeArr removeAllObjects];
            NSArray *array = res[@"result"][@"data"];
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
                singleChoiceModel.title = dic[@"name"];
                singleChoiceModel.typeCode = dic[@"id"];
                [self.typeArr addObject:singleChoiceModel];
            }
            HZSingleChoiceModel *model = [[HZSingleChoiceModel alloc] init];
            model.title = @"全部";
            model.typeCode = @"99";
            [self.typeArr insertObject:model atIndex:0];
            [self.otherTableView reloadData];
        } else {
            [XDUtil showToast:res[@"message"]];
        }
    } fail:^(NSError *error) {
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

//  获取工单状态列表
- (void)getOrderStatusList {
    @weakify(self);
    [XDHTTPRequst getOrderStatusListWithDic:nil succeed:^(id res) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [self.flowStatusArr removeAllObjects];
            NSArray *array = res[@"result"];
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
                singleChoiceModel.title = dic[@"name"];
                singleChoiceModel.typeCode = dic[@"id"];
                [self.flowStatusArr addObject:singleChoiceModel];
            }
            HZSingleChoiceModel *model = [[HZSingleChoiceModel alloc] init];
            model.title = @"全部";
            model.typeCode = @"99";
            [self.flowStatusArr insertObject:model atIndex:0];
            [self.otherTableView reloadData];
        } else {
            [XDUtil showToast:res[@"message"]];
        }
    } fail:^(NSError *error) {
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 获取投诉类型列表
- (void)getComplainTypeList {
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@100
                          };
    @weakify(self);
    [XDHTTPRequst getComplainTypeListWithDic:dic succeed:^(id res) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [self.typeArr removeAllObjects];
            NSArray *array = res[@"result"][@"data"];
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
                singleChoiceModel.title = dic[@"name"];
                singleChoiceModel.typeCode = dic[@"id"];
                singleChoiceModel.selectedStatus = (i == 0);
                [self.typeArr addObject:singleChoiceModel];
            }
            HZSingleChoiceModel *model = [[HZSingleChoiceModel alloc] init];
            model.title = @"全部";
            model.typeCode = @"99";
            [self.typeArr insertObject:model atIndex:0];
            [self.otherTableView reloadData];
        } else {
            [XDUtil showToast:res[@"message"]];
        }
    } fail:^(NSError *error) {
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

//  获取工单状态列表
- (void)getComplainStatusList {
    @weakify(self);
    [XDHTTPRequst getComplainStatusListWithDic:nil succeed:^(id res) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [self.flowStatusArr removeAllObjects];
            NSArray *array = res[@"result"];
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
                singleChoiceModel.title = dic[@"name"];
                singleChoiceModel.typeCode = dic[@"id"];
                [self.flowStatusArr addObject:singleChoiceModel];
            }
            HZSingleChoiceModel *model = [[HZSingleChoiceModel alloc] init];
            model.title = @"全部";
            model.typeCode = @"99";
            [self.flowStatusArr insertObject:model atIndex:0];
            [self.otherTableView reloadData];
        } else {
            [XDUtil showToast:res[@"message"]];
        }
    } fail:^(NSError *error) {
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark --------按钮点击事件
// 返回
- (void)backAction {
    [self hideOtherTableView];
}

// 重置
- (void)resetAction{
    // 重置搜索条件
    self.completeStatusChoice = nil;
    self.typeChoice = nil;
    self.flowStatusChoice = nil;
    [self.menuTableView reloadData];
}

// 确定
- (void)sureAction{
    [self showHideSidebar];
}
 
// 父类方法，当slidebar隐藏时调用
- (void)slideToRight {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.completeStatusChoice forKey:@"isFinish"];
    [dic setValue:self.typeChoice forKey:@"typeId"];
    [dic setValue:self.flowStatusChoice forKey:@"statusId"];
    _backBlock(dic);
}

// 父类方法，当slidebar出现时调用
- (void)sidebarDidShown{
    [_menuTableView reloadData];
}

// 滑动手势
- (void)panAction:(UIPanGestureRecognizer*)recoginzer{
    [self panDetected:recoginzer];
}

//一级页面 tableView中按钮点击事件
#pragma mark - private
- (void)showOtherTableView{
    [UIView animateWithDuration:0.2 animations:^{
        _frame.origin.x = 0;
        _otherContainerView.frame = _frame;
    }];
}

- (void)hideOtherTableView{
    [UIView animateWithDuration:0.2 animations:^{
        _frame.origin.x = _frame.size.width;
        _otherContainerView.frame = _frame;
    }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _menuTableView) {
        return _firstArray.count;
    } else if (tableView == _otherTableView){
        return _otherTableDatasource.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (tableView == _menuTableView) {
        InfoTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"InfoTableViewCell" owner:self options:nil]firstObject];
        cell.typeLabel.text = _firstArray[row];
        if (row == 0) {
            cell.detailLabel.text = self.completeStatusChoice.title;
        } else if (row == 1) {
            cell.detailLabel.text = self.typeChoice.title;
        } else {
            cell.detailLabel.text = self.flowStatusChoice.title;
        }
        return cell;
    } else if (tableView == _otherTableView) {
        static NSString *detailCellIdentifier = @"detailCellIdentifier";
        HZSingleChoiceModel *choice = _otherTableDatasource[indexPath.row];
        DetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailInfoTableViewCell" owner:self options:nil] firstObject];
        }
        cell.detailLabel.text = choice.title;
        if ((_otherTableDataType == 1 &&[choice.typeCode isEqual:self.completeStatusChoice.typeCode]) || (_otherTableDataType == 2 && [choice.typeCode isEqual:self.typeChoice.typeCode]) || (_otherTableDataType == 3 && [choice.typeCode isEqual:self.flowStatusChoice.typeCode])) {
            cell.checkImgView.hidden = NO;
        } else {
            cell.checkImgView.hidden = YES;
        }
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (tableView == _menuTableView) {
        if (row == 0) {
            _otherTableDataType = 1;
            _otherTableDatasource = self.completeStatusArr;
        } else if (row == 1) {
            _otherTableDataType = 2;
            _otherTableDatasource = self.typeArr;
        } else if (row == 2) {
            _otherTableDataType = 3;
            _otherTableDatasource = self.flowStatusArr;
        }
        [_otherTableView reloadData];
        [self showOtherTableView];
    } else if (tableView == _otherTableView) {
        if (_otherTableDataType == 1) {
            self.completeStatusChoice = _otherTableDatasource[row];
        } else if (_otherTableDataType == 2){
            self.typeChoice = _otherTableDatasource[row];
        }  else if (_otherTableDataType == 3){
            self.flowStatusChoice = _otherTableDatasource[row];
        }
        [_menuTableView reloadData];
        [self hideOtherTableView];
    }
}

#pragma mark - lazyLoad

- (NSMutableArray *)completeStatusArr {
    if (!_completeStatusArr) {
        _completeStatusArr = [[NSMutableArray alloc] init];
    }
    return _completeStatusArr;
}

- (NSMutableArray *)typeArr {
    if (!_typeArr) {
        _typeArr = [[NSMutableArray alloc] init];
    }
    return _typeArr;
}

- (NSMutableArray *)flowStatusArr {
    if (!_flowStatusArr) {
        _flowStatusArr = [[NSMutableArray alloc] init];
    }
    return _flowStatusArr;
}

@end
