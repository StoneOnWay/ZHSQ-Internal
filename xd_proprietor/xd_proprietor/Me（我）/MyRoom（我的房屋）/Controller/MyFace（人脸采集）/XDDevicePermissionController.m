//
//  Created by cfsc on 2020/7/17.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDDevicePermissionController.h"
#import "XDDevicePermissionCell.h"
#import "GSPopoverViewController.h"
#import "XDTypePopCell.h"
#import "XDCommunityPermissionModel.h"

@interface XDDevicePermissionController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorViewConstraint;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *deviceSelectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowDownImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UIView *deviceInfoView;
@property (weak, nonatomic) IBOutlet UITableView *deviceInfoTableView;
@property (nonatomic, strong) UITableView *deviceListTableView;
@property (strong, nonatomic) GSPopoverViewController *popVC;
@property (nonatomic, assign) NSInteger selIndex;

@end

@implementation XDDevicePermissionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备详情及权限";
    self.selIndex = 0;
    XDCommunityPermissionModel *model = self.permissionArray[0];
    self.deviceLabel.text = model.deviceName;
    [self setUpUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popVCAppear) name:GSPopoverViewControllerDidAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popVCDisAppear) name:GSPopoverViewControllerDidDisappearNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)popVCAppear {
    self.deviceLabel.textColor = RGB(25, 144, 255);
    self.arrowDownImageView.image = [UIImage imageNamed:@"btn_up"];
}

- (void)popVCDisAppear {
    self.deviceLabel.textColor = [UIColor darkGrayColor];
    self.arrowDownImageView.image = [UIImage imageNamed:@"btn_down"];
}

- (void)setUpUI {
    NSString *str = [NSString stringWithFormat:@"%@等设备下发失败", self.errorTipStr];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    self.errorViewConstraint.constant = rect.size.height + 30;
    self.errorLabel.text = str;
    self.deviceInfoTableView.delegate = self;
    self.deviceInfoTableView.dataSource = self;
    self.deviceInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.deviceInfoTableView.scrollEnabled = NO;
    [self.deviceInfoTableView registerNib:[UINib nibWithNibName:@"XDDevicePermissionCell" bundle:nil] forCellReuseIdentifier:@"XDDevicePermissionCell"];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"重新下发" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(kScreenWidth * 0.1, 25, kScreenWidth * 0.8, 50);
    button.layer.cornerRadius = 5.f;
    button.layer.masksToBounds = YES;
    button.backgroundColor = RGB(19, 173, 86);
    [button addTarget:self action:@selector(accessPermission) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:button];
    self.deviceInfoTableView.tableFooterView = footer;
}

- (void)setUpErrorLabel {
    self.errorTipStr = @"";
    for (XDCommunityPermissionModel *model in self.permissionArray) {
        if (model.faceStatus.integerValue != 1) {
            if (self.errorTipStr.length == 0) {
                self.errorTipStr = model.deviceName;
            } else {
                self.errorTipStr = [NSString stringWithFormat:@"%@、%@", self.errorTipStr, model.deviceName];
            }
        }
    }
    if (self.errorTipStr.length == 0) {
        // 所有设备都下发成功
        self.errorViewConstraint.constant = 0;
    } else {
        NSString *str = [NSString stringWithFormat:@"%@等设备下发失败", self.errorTipStr];
        CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        self.errorViewConstraint.constant = rect.size.height + 30;
        self.errorLabel.text = str;
    }
}

- (void)accessPermission {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    XDCommunityPermissionModel *model = self.permissionArray[self.selIndex];
    NSDictionary *dic = @{
        @"cardStatus":model.cardStatus,
        @"deviceId":model.deviceId,
        @"faceStatus":model.faceStatus,
        @"id":self.userModel.userID,
        @"personStatus":model.personStatus,
        @"projectId":loginInfo.userModel.currentDistrict.projectId,
        @"roomId":self.roomId,
        @"type":@"1"
    };
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst accessSinglePermissionWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            NSDictionary *dic = @{
                @"projectId":loginInfo.userModel.currentDistrict.projectId,
                @"phaseId":self.phaseId,
                @"personId":self.userModel.userID
            };
            [XDHTTPRequst getAllPermissionsListWithDic:dic succeed:^(id res) {
                [MBProgressHUD hideHUD];
                if ([res[@"code"] integerValue] == 200) {
                    self.permissionArray = [XDCommunityPermissionModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
                    [self setUpErrorLabel];
                    [self.deviceInfoTableView reloadData];
                }
            } fail:^(NSError *error) {
                [MBProgressHUD hideHUD];
            }];
        } else {
            [MBProgressHUD hideHUD];
            [XDUtil showToast:res[@"message"]];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.deviceListTableView) {
        return self.permissionArray.count;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.deviceListTableView) {
        XDCommunityPermissionModel *model = self.permissionArray[indexPath.row];
        XDTypePopCell *cell = [XDTypePopCell cellWithTableView:tableView];
        cell.textLabels.text = model.deviceName;
        if (indexPath.row == self.selIndex) {
            cell.checkImageView.hidden = NO;
            cell.textLabels.textColor = RGB(25, 144, 255);
        } else {
            cell.checkImageView.hidden = YES;
            cell.textLabels.textColor = RGB(74, 74, 74);
        }
        return cell;
    }
    XDCommunityPermissionModel *model = self.permissionArray[self.selIndex];
    XDDevicePermissionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDDevicePermissionCell"];
    cell.selectionStyle = 0;
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"设备位置";
        cell.valueLabel.text = model.location;
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = @"下发状态";
        cell.valueLabel.text = model.faceStatusText;
    } else if (indexPath.row == 2) {
        cell.titleLabel.text = @"下发时间";
        cell.valueLabel.text = model.distributeTime;
    } else if (indexPath.row == 3) {
        cell.titleLabel.text = @"设备状态";
        cell.valueLabel.text = model.deviceStatusText;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDCommunityPermissionModel *model = self.permissionArray[indexPath.row];
    self.selIndex = indexPath.row;
    self.deviceLabel.text = model.deviceName;
    [self.popVC dissPopoverViewWithAnimation:YES];
}

- (IBAction)deviceSelectAction:(UIButton *)sender {
    [self setUpPopView:sender];
    CGRect rect = sender.frame;
    rect.origin.y += 50;
    self.popVC.showAnimation = GSPopoverViewShowAnimationBottomTop;
    [self.popVC showPopoverWithRect:rect animation:YES];
}

- (void)setUpPopView:(UIButton *)sender {
    _deviceListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0,  sender.width, 210)];
    _deviceListTableView.delegate = self;
    _deviceListTableView.dataSource = self;
    _deviceListTableView.rowHeight = 50;
//    _deviceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _deviceListTableView.backgroundColor = [UIColor whiteColor];
    
    self.popVC = [[GSPopoverViewController alloc] initWithShowView:_deviceListTableView];
    self.popVC.borderWidth = 1;
    self.popVC.borderColor = BianKuang;
    self.popVC.cornerRadius = 0;
//    self.popVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
}

@end
