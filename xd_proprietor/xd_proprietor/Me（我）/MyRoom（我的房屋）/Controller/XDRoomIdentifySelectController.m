//
//  Created by cfsc on 2020/3/13.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDRoomIdentifySelectController.h"
#import "XDRoomIdentifyCell.h"
#import "XDRoomIdentifyVerifyController.h"

@interface XDRoomIdentifySelectController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation XDRoomIdentifySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    self.title = @"选择身份";
}

- (void)configTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XDRoomIdentifyCell" bundle:nil] forCellReuseIdentifier:@"XDRoomIdentifyCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(20, 35, kScreenWidth-40, 50);
    [confirmBtn setBackgroundColor:buttonColor];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(okAction) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:confirmBtn];
    confirmBtn.layer.cornerRadius = 5.f;
    confirmBtn.layer.masksToBounds = YES;
    self.tableView.tableFooterView = footerView;
}

- (void)okAction {
    NSString *type = @"";
    if (self.currentIndexPath.row == 0) {
        type = @"YZ";
    } else if (self.currentIndexPath.row == 1) {
        type = @"JS";
    } else if (self.currentIndexPath.row == 2) {
        type = @"ZH";
    }
    // 推出信息填写界面
    XDRoomIdentifyVerifyController *verifyVC = [[XDRoomIdentifyVerifyController alloc] init];
    verifyVC.roomModel = self.roomModel;
    verifyVC.roomIdentifyType = type;
    [self.navigationController pushViewController:verifyVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDRoomIdentifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDRoomIdentifyCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    NSString *imageName = indexPath.row == self.currentIndexPath.row ? @"singleSelected" : @"singleUnselected";
    cell.stateImageView.image = [UIImage imageNamed:imageName];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"业主";
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = @"家属";
    } else if (indexPath.row == 2) {
        cell.titleLabel.text = @"租户";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    [self.tableView reloadData];
}


@end
