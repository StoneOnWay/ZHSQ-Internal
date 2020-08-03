//
//  XDHomePageViewController.m
//  首页
//
//  Created by mason on 2018/8/31.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDHomePageViewController.h"
#import "XDHomeAddressView.h"
#import "XDHomeEventCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "XDMarqueeCollectionViewCell.h"
#import "XDMenuItemCollectionViewCell.h"
#import "XDBannerCell.h"
#import "XDHomeMenuModel.h"
#import "XDHomeSectionHeaderCollectionReusableView.h"
#import <objc/message.h>
#import "XDInfoNewDetailNetController.h"
#import "XDInformNewsListController.h"
#import "XDOpenClokController.h"
#import "AFHTTPSessionManager.h"
#import "XDMaskingTipController.h"
#import "XDContentInfoModel.h"
#import "XDActivityCell.h"
#import "XDActivityModel.h"
#import "XDCollectionActivityHeaderReusableView.h"
#import "XDActivityListController.h"
#import "XDActivityDetailController.h"
#import "XDServerConfigController.h"
#import "XDServerDataManager.h"
#import "XDServerConfigCellModel.h"

static NSString * const kEventCell = @"kEventCell";
static NSString * const kMarqueeCell = @"kMarqueeCell";
static NSString * const kMyServiceCell = @"kMyServiceCell";
static NSString * const kBannerCell = @"kBannerCell";
static NSString * const kActivityCell = @"kActivityCell";

@interface XDHomePageViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate,
SDCycleScrollViewDelegate
>
{
    NSString *projectID;
    dispatch_group_t refreshNewsGroup;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *queueArr; // 热点数据源
@property (strong, nonatomic) NSMutableArray *bannerArr; // 轮播图数据源
@property (strong, nonatomic) NSMutableArray *activityArr; // 活动数据源
@property (strong, nonatomic) NSMutableArray *serverArr; // 服务数据源
@property (nonatomic, strong) XDLoginInfoModel *loginInfo;

@end

@implementation XDHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = RGB(44, 52, 71);
    self.loginInfo = [XDArchiverManager loginInfo];
    projectID = self.loginInfo.userModel.currentDistrict.projectId;
    [self refreshToken];
    [self setupNavigationBarView];
    [self setupCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsData) name:@"DidPublishNewsNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:XDActivityDidUpdateRegistNoti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DidPublishNewsNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XDActivityDidUpdateRegistNoti object:nil];
}

- (void)updateData {
    [self getActivityData];
}

- (void)refreshToken {
    // 更新token，成功后加载页面，不成功进入登录页面
    [XDHTTPRequst refreshTokenWithOldToken:self.loginInfo.tokenModel.access_token succeed:^(NSDictionary *res) {
        if ([res[@"code"] integerValue] == 200) {
            XDLoginTokenModel *model = [XDLoginTokenModel mj_objectWithKeyValues:res[@"result"]];
            self.loginInfo.tokenModel = model;
            [XDArchiverManager saveLoginInfo:self.loginInfo];
            NSLog(@"token更新成功");
            [self.collectionView.mj_header beginRefreshing];
            // 更新业主信息并检查是业主或游客
            [self checkOwnerPermission];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
            [self dealRefreshTokenFail];
        }
    } fail:^(NSError *error) {
        NSLog(@"token更新失败---%@", error);
        [XDHTTPRequst showErrorMessageWith:error];
        [self dealRefreshTokenFail];
    }];
}

- (void)dealRefreshTokenFail {
    // token失效进入的登录界面，需要清空登录信息
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    loginInfo = nil;
    [XDArchiverManager saveLoginInfo:loginInfo];
    [[XDCommonBusiness shareInstance] goToLoginVC];
}

// 请求首页数据
- (void)refreshNewsData {
    refreshNewsGroup = dispatch_group_create();
    // 获取热点关注数据
    [self getHotFocusData];
    // 获取轮播图数据
    [self getBannerData];
    // 获取活动数据
    [self getActivityData];
    // 获取我的应用列表
    [self getMyPrograms];
    dispatch_group_notify(refreshNewsGroup, dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    });
}

// 获取我的应用列表
- (void)getMyPrograms {
    dispatch_group_enter(refreshNewsGroup);
    [XDHTTPRequst getAllProgramsSucceed:^(id res) {
        dispatch_group_leave(refreshNewsGroup);
        if ([res[@"code"] integerValue] == 200) {
            [[XDServerDataManager shareDataManager] setUpData:res[@"result"]];
            [self configDataSource];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        dispatch_group_leave(refreshNewsGroup);
//        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)getActivityData {
    if (!projectID) {
        return;
    }
    WEAKSELF
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@(PageSiz),
                          @"projectId":projectID,
                          @"isClosed":@0,
                          @"isEnd":@0
                          };
    dispatch_group_enter(refreshNewsGroup);
    [XDHTTPRequst getActivityListWithDic:dic succeed:^(id res) {
        dispatch_group_leave(refreshNewsGroup);
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.activityArr removeAllObjects];
            NSArray *array = res[@"result"][@"data"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                XDActivityModel *model = [XDActivityModel mj_objectWithKeyValues:dic];
                [weakSelf.activityArr addObject:model];
            }
//            NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4, 1)];
//            [weakSelf.collectionView reloadSections:sections];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        dispatch_group_leave(refreshNewsGroup);
//        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)getHotFocusData {
    if (!projectID) {
        return;
    }
    WEAKSELF
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@(PageSiz),
                          @"announcementTypeId":hotFocusTypeID,
                          @"projectId":projectID,
                          @"auditStatus":@1,
                          @"pushStatus":@1,
                          @"receiver":[[XDCommonBusiness shareInstance] getCurrentUserType]
                          };
    dispatch_group_enter(refreshNewsGroup);
    [XDHTTPRequst getContentListWithDic:dic succeed:^(id res) {
        dispatch_group_leave(refreshNewsGroup);
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.queueArr removeAllObjects];
            NSArray *array = res[@"result"][@"data"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                XDContentInfoModel *model = [XDContentInfoModel mj_objectWithKeyValues:dic];
                [weakSelf.queueArr addObject:model];
            }
//            NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 1)];
//            [weakSelf.collectionView reloadSections:sections];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        dispatch_group_leave(refreshNewsGroup);
//        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)getBannerData {
    if (!projectID) {
        return;
    }
    WEAKSELF
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@(PageSiz),
                          @"announcementTypeId":bannerTypeID,
                          @"projectId":projectID,
                          @"auditStatus":@1,
                          @"pushStatus":@1,
                          @"receiver":[[XDCommonBusiness shareInstance] getCurrentUserType]
                          };
    dispatch_group_enter(refreshNewsGroup);
    [XDHTTPRequst getContentListWithDic:dic succeed:^(id res) {
        dispatch_group_leave(refreshNewsGroup);
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.bannerArr removeAllObjects];
            NSArray *array = res[@"result"][@"data"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                XDContentInfoModel *model = [XDContentInfoModel mj_objectWithKeyValues:dic];
                [weakSelf.bannerArr addObject:model];
            }
//            NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 1)];
//            [weakSelf.collectionView reloadSections:sections];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        dispatch_group_leave(refreshNewsGroup);
//        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)checkOwnerPermission {
    // 更新业主信息
    @weakify(self)
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    [XDHTTPRequst getUserInfoCacheSucceed:^(id res) {
        @strongify(self)
        if ([res[@"code"] integerValue] == 200) {
            XDUserModel *userModel = [XDUserModel mj_objectWithKeyValues:res[@"result"]];
            loginInfo.userModel = userModel;
            [XDArchiverManager saveLoginInfo:loginInfo];
            if (!userModel.currentDistrict.roomId) {
                [self showMaskingTip];
            }
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
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

#pragma mark - UI
- (void)setupNavigationBarView {
    XDHomeAddressView *homeAddressView = [XDHomeAddressView loadFromNib];
    homeAddressView.projectLabel.text = self.loginInfo.userModel.currentDistrict.projectName;
    homeAddressView.frame = CGRectMake(0, 0, kScreenWidth - 100.f, NavHeight-StatusBarHeight);
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:homeAddressView];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)setupCollectionView {
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavHeight - TabbarHeight) collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = RGB(243, 243, 243);
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDHomeEventCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDHomeEventCollectionViewCell class])];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDMarqueeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDMarqueeCollectionViewCell class])];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDMenuItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDMenuItemCollectionViewCell class])];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDActivityCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDActivityCell class])];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDCollectionActivityHeaderReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XDCollectionActivityHeaderReusableView class])];
    [collectionView registerClass:[XDBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([XDBannerCell class])];
    [collectionView registerClass:[XDHomeSectionHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XDHomeSectionHeaderCollectionReusableView class])];
    [self configDataSource];
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewsData)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = Header;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dic = self.dataSource[section];
    if ([dic[@"type"] isEqualToString:kEventCell] || [dic[@"type"] isEqualToString: kMyServiceCell]) {
        return [dic[@"value"] count];
    } else if ([dic[@"type"] isEqualToString: kMarqueeCell] || [dic[@"type"] isEqualToString: kBannerCell] || [dic[@"type"] isEqualToString: kActivityCell]) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section];
    if ([dic[@"type"] isEqualToString:kEventCell]) {
        XDHomeEventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDHomeEventCollectionViewCell class]) forIndexPath:indexPath];
        cell.homeMenuModel = dic[@"value"][indexPath.row];
        return cell;
    } else if ([dic[@"type"] isEqualToString: kMarqueeCell]) {
        XDMarqueeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDMarqueeCollectionViewCell class]) forIndexPath:indexPath];
        if (_queueArr.count>0) {
            [cell setAllDataWithArr: _queueArr];
        }
        return cell;
    } else if ([dic[@"type"] isEqualToString: kMyServiceCell]) {
        XDMenuItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDMenuItemCollectionViewCell class]) forIndexPath:indexPath];
        cell.homeMenuModel = dic[@"value"][indexPath.row];
        return cell;
    } else if ([dic[@"type"] isEqualToString: kBannerCell]) {
        XDBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDBannerCell class]) forIndexPath:indexPath];
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, KCycleScrollViewHeight) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        cycleScrollView.zoomType = YES;
        cycleScrollView.autoScroll = YES;
        cycleScrollView.currentPageDotColor = [UIColor blackColor];
        cycleScrollView.pageDotColor = [UIColor colorWithWhite:0.6 alpha:0.5];
        cycleScrollView.pageControlDotSize = CGSizeMake(10, 3); // pageControl小点的大小
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cycleScrollView.maxWidth = kScreenWidth * 300 / 414;
        cycleScrollView.maxHeight = KCycleScrollViewHeight * 200 / 250;
        NSMutableArray *imageUrlArray = [NSMutableArray array];
        for (XDContentInfoModel *model in self.bannerArr) {
            [imageUrlArray addObject:model.coverUrl];
        }
        cycleScrollView.imageURLStringsGroup = imageUrlArray;
        cycleScrollView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:cycleScrollView];
        return cell;
    } else if ([dic[@"type"] isEqualToString: kActivityCell]) {
        XDActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDActivityCell class]) forIndexPath:indexPath];
        cell.dataArray = self.activityArr;
        cell.didSelectIndex = ^(NSIndexPath * _Nonnull indexPath) {
            XDActivityModel *model = self.activityArr[indexPath.row];
            XDActivityDetailController *detailVC = [[XDActivityDetailController alloc] init];
            detailVC.activity = model;
            [self.navigationController pushViewController:detailVC animated:YES];
        };
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat margin = 0.5f;//1.f / [UIScreen mainScreen].scale;
    NSDictionary *dic = self.dataSource[indexPath.section];
    if ([dic[@"type"] isEqualToString:kEventCell]) {
        CGFloat width = kScreenWidth / 4.f;
        CGFloat height = 127.f * kScreenWidth / 375.f;
        if ([XDUtil isIPad]) {
            height = 85 * kScreenWidth / 375.f;
        }
        return CGSizeMake(width, height);
    } else if ([dic[@"type"] isEqualToString: kMarqueeCell]) {
        return CGSizeMake(kScreenWidth, 55.f);
    } else if ([dic[@"type"] isEqualToString: kMyServiceCell]) {
        return CGSizeMake((kScreenWidth - 3 * margin)/ 4.f, (kScreenWidth - 3 * margin)/ 4.f);
    } else if ([dic[@"type"] isEqualToString: kBannerCell]) {
        return CGSizeMake(kScreenWidth, KCycleScrollViewHeight);
    } else if ([dic[@"type"] isEqualToString: kActivityCell]) {
        if (self.activityArr.count != 0) {
            CGFloat width = 300.f * (kScreenWidth - 10) / (414.f - 10);
            CGFloat height = width * 105 / 300 + 90 + 50;
            return CGSizeMake(kScreenWidth, height + 5);
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    NSDictionary *dic = self.dataSource[section];
    if ([dic[@"type"] isEqualToString: kMyServiceCell]) {
        return 0.5f;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    NSDictionary *dic = self.dataSource[section];
    if ([dic[@"type"] isEqualToString: kMyServiceCell]) {
        return 0.5f;
    }
    return 0;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.collectionView] == YES) {
        if ([self.collectionView indexPathForItemAtPoint:[touch locationInView:self.collectionView]]) {
            return NO;}
    }
    return YES;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section];
    if ([dic[@"type"] isEqualToString: kActivityCell]) {
        XDCollectionActivityHeaderReusableView *activityView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([XDCollectionActivityHeaderReusableView class]) forIndexPath:indexPath];
        activityView.titleLabel.text = @"社区活动";
        activityView.getMoreAction = ^{
            XDActivityListController *activityList = [[XDActivityListController alloc] init];
            [self.navigationController pushViewController:activityList animated:YES];
        };
        return activityView;
    } else if ([dic[@"type"] isEqualToString:kMyServiceCell]) {
        XDCollectionActivityHeaderReusableView *activityView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([XDCollectionActivityHeaderReusableView class]) forIndexPath:indexPath];
        activityView.titleLabel.text = @"我的应用";
        activityView.getMoreAction = ^{
            XDServerConfigController *configVC = [[XDServerConfigController alloc] init];
            configVC.myProgramsDidUpdate = ^{
                [self configDataSource];
                [self.collectionView reloadData];
            };
            [self.navigationController pushViewController:configVC animated:YES];
        };
        return activityView;
    }
    XDHomeSectionHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([XDHomeSectionHeaderCollectionReusableView class]) forIndexPath:indexPath];
    headerView.titleLabel.text = @"";
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section];
    XDMarqueeCollectionViewCell *cell = (XDMarqueeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    XDHomeMenuModel *homeMenuModel = dic[@"value"][indexPath.row];
    
    // 游客权限控制
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *title = homeMenuModel.title;
    if (loginInfo.userModel.currentDistrict.joinStatus.integerValue != 1) {
        if ([[XDServerDataManager shareDataManager] isUnusableProgram:title]) {
            NSString *str = [NSString stringWithFormat:@"您还未入伙，无法使用%@功能", title];
            [XDUtil showToast:str];
            return;
        }
    }
    // 网页
    if (homeMenuModel.vcType == XDVCTypeJxbWeb) {
        XDHybridWebController *detailVC = [[XDHybridWebController alloc] initWithURLString:homeMenuModel.jxbUrl];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    // 业务
    if (indexPath.section == 1) {
        if (_queueArr.count > cell.marquee.currentIndex) {
            XDContentInfoModel *model = [_queueArr objectAtIndex:cell.marquee.currentIndex];
            XDInfoNewDetailNetController *info = [[XDInfoNewDetailNetController alloc] init];
            info.infoModel = model;
            [self.navigationController pushViewController:info animated:YES];
        }
    } else {
        if (homeMenuModel.viewControllerStr.length > 0 && ![homeMenuModel.viewControllerStr isEqualToString:@""]) {
            UIViewController *vc = nil;
            if (homeMenuModel.vcType == XDVCTypeAlloc) {
                vc = [[NSClassFromString(homeMenuModel.viewControllerStr) alloc] init];
            } else if (homeMenuModel.vcType == XDVCTypeStoryboard) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                vc= [storyboard instantiateViewControllerWithIdentifier:homeMenuModel.viewControllerStr];
            } else {
                vc = [UIViewController new];
            }
            vc.title = homeMenuModel.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.dataSource[section];
    if ([dic[@"type"] isEqualToString: kMyServiceCell]) {
        return CGSizeMake(kScreenWidth, 60.f);
    } else if ([dic[@"type"] isEqualToString: kBannerCell]) {
        return CGSizeMake(kScreenWidth, 0.f);
    } else if ([dic[@"type"] isEqualToString: kActivityCell]) {
        if (self.activityArr.count != 0) {
            return CGSizeMake(kScreenWidth, 60.f);
        }
    }
    return CGSizeZero;
}

#pragma mark - cycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [cycleScrollView adjustWhenControllerViewWillAppera];
    XDContentInfoModel *model = self.bannerArr[index];
    XDInfoNewDetailNetController *newsDetailVC = [[XDInfoNewDetailNetController alloc] init];
    newsDetailVC.infoModel = model;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

- (void)configDataSource {
    [self.dataSource removeAllObjects];
#pragma mark 门禁开锁 报事报修 投诉建议 锁车解锁
    XDHomeMenuModel *lockModel = [XDHomeMenuModel new];
    lockModel.title = @"门禁开锁";
    lockModel.icon = @"btn_home_lock";
    lockModel.viewControllerStr = @"XDOpenClokController";
    
    XDHomeMenuModel *visitModel = [XDHomeMenuModel new];
    visitModel.title = @"访客邀约";
    visitModel.icon = @"btn_home_visit";
    visitModel.viewControllerStr = @"XDVisitorListController";
    
    XDHomeMenuModel *visualModel = [XDHomeMenuModel new];
    visualModel.title = @"可视对讲";
    visualModel.icon = @"btn_home_visual";
    visualModel.viewControllerStr = @"XDRealPlayerController";
    
    XDHomeMenuModel *deblockModel = [XDHomeMenuModel new];
    deblockModel.title = @"智能锁车";
    deblockModel.icon = @"btn_home_lock_car";
    deblockModel.viewControllerStr = @"XDDeblockingController";
    
    [self.dataSource addObject:@{@"type" : kEventCell, @"value" : @[lockModel, visitModel, visualModel, deblockModel]}];
    
#pragma mark 热点关注 && 轮播图
    [self.dataSource addObject:@{@"type" : kMarqueeCell}];
    [self.dataSource addObject:@{@"type" : kBannerCell}];

#pragma mark 我的服务
    [self.dataSource addObject:@{@"type" : kMyServiceCell, @"value" : [XDServerDataManager shareDataManager].homeMenuArray}];
    
#pragma mark 活动报名
    [self.dataSource addObject:@{@"type" : kActivityCell}];
    
    [self.collectionView reloadData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)queueArr {
    if (!_queueArr) {
        _queueArr = [NSMutableArray array];
    }
    return _queueArr;
}

- (NSMutableArray *)bannerArr {
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

- (NSMutableArray *)activityArr {
    if (!_activityArr) {
        _activityArr = [NSMutableArray array];
    }
    return _activityArr;
}

- (NSMutableArray *)serverArr {
    if (!_serverArr) {
        _serverArr = [NSMutableArray array];
    }
    return _serverArr;
}

@end
