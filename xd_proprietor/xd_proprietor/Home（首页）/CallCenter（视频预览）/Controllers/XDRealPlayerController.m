//
//  XDRealPlayerController.m
//  可视对讲
//
//  Created by stone on 24/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDRealPlayerController.h"
#import "XDRealPlayCell.h"
#import "CTCPlayerView.h"
#import "XDCallCenterBusiness.h"

#define CELL_IDENTIFY @"XDRealPlayCell"

@interface XDRealPlayerController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CTCPlayerView *playView;    /**< 显示预览视频View*/
@property (nonatomic, strong) XDCallCenterBusiness *callCenterBusiness;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *deviceArray;
@end

@implementation XDRealPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    self.callCenterBusiness = [XDCallCenterBusiness sharedInstance];
    [self.callCenterBusiness initialHikSdk:^(BOOL success) {
        if (!success) {
            NSLog(@"SDK初始化失败！");
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.callCenterBusiness stopRealPlay];
}

- (NSArray *)deviceArray {
    if (!_deviceArray) {
        XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
        _deviceArray = loginInfo.userModel.equipmentInfoBoList;
    }
    return _deviceArray;
}

- (void)setUI {
    self.playView = [[CTCPlayerView alloc] init];
    [self.view addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.top.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.playView.mas_bottom);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = litterBackColor;
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFY bundle:NSBundle.mainBundle] forCellReuseIdentifier:CELL_IDENTIFY];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDRealPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY forIndexPath:indexPath];
    XDEquipmentModel *model = self.deviceArray[indexPath.row];
    cell.nameLabel.text = model.deviceName;
    NSString *imageName = [NSString stringWithFormat:@"video_play%ld", (long)(indexPath.row % 6)];
    cell.staticImageView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.playView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(280 * kScreenWidth / 414.f);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view updateConstraintsIfNeeded];
        [self.view layoutIfNeeded];
    }];
    
    XDEquipmentModel *model = self.deviceArray[indexPath.row];
    CloudVoiceTalkParamsModel *talkModel = [[CloudVoiceTalkParamsModel alloc] init];
    talkModel.deviceSerial = model.deviceSerial;
    talkModel.verifyCode = model.validateCode;
    self.callCenterBusiness.talkModel = talkModel;
    [self.callCenterBusiness startVideoPlay:self.playView];
}

@end
