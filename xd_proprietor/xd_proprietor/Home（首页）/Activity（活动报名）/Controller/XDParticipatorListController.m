//
//  Created by cfsc on 2020/6/29.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDParticipatorListController.h"
#import "XDParticipatorTableCell.h"
#import "XDParticipatorTableCell.h"
#import "XDActivityRegistController.h"

@interface XDParticipatorListController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (nonatomic, strong) NSMutableArray *paricipatorArr;
@property (nonatomic, strong) UILabel *footerLabel;

@end

@implementation XDParticipatorListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报名详情";
    self.applyBtn.layer.cornerRadius = 25.f;
    self.applyBtn.layer.masksToBounds = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDParticipatorTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDParticipatorTableCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:XDActivityDidUpdateRegistNoti object:nil];
    
    [self getParticipatorList];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XDActivityDidUpdateRegistNoti object:nil];
}

- (void)updateData {
    [self getParticipatorList];
}

- (void)setUpFooterLabel:(NSString *)str {
    self.footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.footerLabel.font = [UIFont systemFontOfSize:14];
    self.footerLabel.textColor = RGB(128, 128, 128);
    self.footerLabel.text = str;
    self.footerLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = self.footerLabel;
}

- (void)cancelRegist:(NSIndexPath *)indexPath {
    XDParticipatorModel *model = self.paricipatorArr[indexPath.row];
    if (!model.participatorId) {
        return;
    }
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst cancelRegistActivityWithId:model.participatorId succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [self.paricipatorArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:XDActivityDidUpdateRegistNoti object:nil];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)getParticipatorList {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (!loginInfo.userModel.userID || !self.activity.eventId) {
        return;
    }
    NSDictionary *dic = @{
        @"pageNo":@1,
        @"pageSize":@100,
        @"householdId":loginInfo.userModel.userID,
        @"eventId":self.activity.eventId
    };
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst getActivityParicipatorsWithDic:dic succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [self.paricipatorArr removeAllObjects];
            NSArray *data = res[@"result"][@"data"];
            for (NSDictionary *dic in data) {
                XDParticipatorModel *model = [XDParticipatorModel mj_objectWithKeyValues:dic];
                [self.paricipatorArr addObject:model];
            }
            NSString *footerStr = @"";
            if (self.paricipatorArr.count == 0) {
                [self.applyBtn setTitle:@"报名参加" forState:UIControlStateNormal];
                footerStr = @"还未报名，点击下方按钮参与吧";
            } else {
                [self.applyBtn setTitle:@"继续报名" forState:UIControlStateNormal];
                footerStr = @"点击卡片右上角删除按钮可以取消报名哦";
            }
            [self setUpFooterLabel:footerStr];
            [self.tableView reloadData];
        } else {
           [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (IBAction)applyAction:(id)sender {
    XDActivityRegistController *registVC = [[XDActivityRegistController alloc] init];
    registVC.activity = self.activity;
    [self.navigationController pushViewController:registVC animated:YES];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paricipatorArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDParticipatorModel *model = self.paricipatorArr[indexPath.row];
    XDParticipatorTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDParticipatorTableCell class])];
    cell.participator = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cancelRegist = ^{
        [self cancelRegist:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.paricipatorArr.count == 0) {
        return 0;
    }
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 50)];
    label.text = @"已报名用户";
    label.font = [UIFont systemFontOfSize:22];
    label.textColor = [UIColor blackColor];
    [headerView addSubview:label];
    return headerView;
}

- (NSMutableArray *)paricipatorArr {
    if (!_paricipatorArr) {
        _paricipatorArr = [[NSMutableArray alloc] init];
    }
    return _paricipatorArr;
}

@end
