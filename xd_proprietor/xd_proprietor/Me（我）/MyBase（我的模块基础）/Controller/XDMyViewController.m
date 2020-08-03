//
//  Created by cfsc on 2020/3/4.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDMyViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "XDMenuItemCollectionViewCell.h"
#import "XDHeaderCollectionViewCell.h"
#import "XDPersonalInfoController.h"
#import "XDFlowListController.h"
#import "XDMaskingTipController.h"
#import "XDServerDataManager.h"

static NSString * const kHeaderCell = @"kHeaderCell";
static NSString * const kFunctionCell = @"kFunctionCell";
static NSString * const kFooterCell = @"kFooterCell";

@interface XDMyViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIAlertViewDelegate,
CustomAlertViewDelegate
>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation XDMyViewController
   
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self configDataSource];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupView {
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = UIColorHex(f3f3f3);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDMenuItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDMenuItemCollectionViewCell class])];
    
    // 头部
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDHeaderCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDHeaderCollectionViewCell class])];

    [self.collectionView setContentInset:UIEdgeInsetsMake(-StatusBarHeight, 0, 0, 0)];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource[section][@"value"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XDHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDHeaderCollectionViewCell class]) forIndexPath:indexPath];
        [cell setContent];
        return cell;
    }
    
    XDMenuItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDMenuItemCollectionViewCell class]) forIndexPath:indexPath];
    NSArray *list = self.dataSource[indexPath.section][@"value"];
    cell.homeMenuModel = list[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section];
    XDHomeMenuModel * homeMenuModel = dic[@"value"][indexPath.row];
    
    // 游客权限控制
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *title = homeMenuModel.title;
    if (loginInfo.userModel.currentDistrict.joinStatus.integerValue != 1) {
        if ([[XDServerDataManager shareDataManager] isUnusableProgram:title]) {
            NSString *str = [NSString stringWithFormat:@"您还未入伙，无法使用%@功能", title];
            [XDUtil showToast:str];
        }
    }
    // 网页
    if (homeMenuModel.vcType == XDVCTypeJxbWeb) {
        JXBWebViewController *detailVC = [[JXBWebViewController alloc] initWithURLString:homeMenuModel.jxbUrl];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    // 业务
    if (homeMenuModel.viewControllerStr.length > 0 && ![homeMenuModel.viewControllerStr isEqualToString:@""]) {
        // 工单投诉
        if ([homeMenuModel.viewControllerStr isEqualToString:@"XDFlowListController"]) {
            XDFlowListController *flowVC = [[XDFlowListController alloc] init];
            flowVC.flowStatus = XDFlowStatusAll;
            flowVC.flowType = [homeMenuModel.vcSubType integerValue];
            [self.navigationController pushViewController:flowVC animated:YES];
            return;
        }
        UIViewController *vc = nil;
        if (homeMenuModel.vcType == XDVCTypeAlloc) {
            vc = [NSClassFromString(homeMenuModel.viewControllerStr) new];
        } else if (homeMenuModel.vcType == XDVCTypeStoryboard) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:homeMenuModel.viewControllerStr bundle:nil];
            vc= [storyboard instantiateViewControllerWithIdentifier:homeMenuModel.viewControllerStr];
        } else {
            vc = [UIViewController new];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat margin = 0.5f;//1.f / [UIScreen mainScreen].scale;
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, 127.f + StatusBarHeight);
    }else if (indexPath.section == 2){
        return CGSizeMake(kScreenWidth, 60.0f);
    }
    return CGSizeMake((kScreenWidth - 3 * margin)/ 4.f, (kScreenWidth - 3 * margin)/ 4.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return 0.5f;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return 0.5f;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(kScreenWidth, 15.f);
    }
    return CGSizeZero;
}

- (void) configDataSource {
    
    XDHomeMenuModel *deblockModel = [XDHomeMenuModel new];
    deblockModel.viewControllerStr = @"XDPersonalInfoController";
    [self.dataSource addObject:@{@"type" : kHeaderCell, @"value": @[deblockModel]}];
    
    XDHomeMenuModel *myWorkModel = [XDHomeMenuModel new];
    myWorkModel.title = @"我的报修";
    myWorkModel.icon = @"btn_my_work";
//    myWorkModel.vcType = XDVCTypeStoryboard;
    myWorkModel.viewControllerStr = @"XDFlowListController";
    myWorkModel.vcSubType = [NSString stringWithFormat:@"%ld", (long)XDFlowTypeOrder];
    
    XDHomeMenuModel *complainModel = [XDHomeMenuModel new];
    complainModel.title = @"我的投诉";
    complainModel.icon = @"btn_my_complain";
//    complainModel.vcType = XDVCTypeStoryboard;
    complainModel.viewControllerStr = @"XDFlowListController";
    complainModel.vcSubType = [NSString stringWithFormat:@"%ld", (long)XDFlowTypeComplain];

    XDHomeMenuModel *carManageModel = [XDHomeMenuModel new];
    carManageModel.title = @"车辆管理";
    carManageModel.icon = @"btn_my_car";
    carManageModel.viewControllerStr = @"XDCarListController";
//    carManageModel.viewControllerStr = @"XDNotOpenController";

    XDHomeMenuModel *roomModel = [XDHomeMenuModel new];
    roomModel.title = @"我的房屋";
    roomModel.icon = @"btn_my_room";
    roomModel.vcType = XDVCTypeStoryboard;
    roomModel.viewControllerStr = @"XDPageContainerController";
    
    XDHomeMenuModel *communityAnnouncementModel = [XDHomeMenuModel new];
    communityAnnouncementModel.title = @"包裹查询";
    communityAnnouncementModel.icon = @"btn_home_notice";
    communityAnnouncementModel.vcType = XDVCTypeJxbWeb;
    communityAnnouncementModel.jxbUrl = PackageSearchUrl;
    
    XDHomeMenuModel *personalModel = [XDHomeMenuModel new];
    personalModel.title = @"个人资料";
    personalModel.icon = @"btn_my_datum";
    personalModel.viewControllerStr = @"XDPersonalInfoController";
    
    XDHomeMenuModel *settingModel = [XDHomeMenuModel new];
    settingModel.title = @"设置";
    settingModel.icon = @"btn_my_intercalate";
    settingModel.viewControllerStr = @"XDSettingsController";
    
    XDHomeMenuModel *emptyModel = [XDHomeMenuModel new];
    
    NSArray *menuArray = @[myWorkModel, complainModel, carManageModel, roomModel, communityAnnouncementModel, personalModel, settingModel, emptyModel];
    [self.dataSource addObject:@{@"type" : kFunctionCell, @"value" : menuArray}];
    
    [self.collectionView reloadData];
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)showMaskingTip {
    // 弹出提示选择房屋
    XDMaskingTipController *maskVC = [[XDMaskingTipController alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        maskVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    } else {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [self.tabBarController presentViewController:maskVC animated:NO completion:nil];
}

@end
