//
//  XDLiveChargeController.m
//  xd_proprietor
//
//  Created by stone on 15/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDLiveChargeController.h"
#import "XDLiveChargeConfigModel.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "XDLiveChargeCell.h"
#import "XDParkPayController.h"

#define kMargin 0.5

@interface XDLiveChargeController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation XDLiveChargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生活缴费";
    self.view.backgroundColor = litterBackColor;
    [self configDataSource];
    [self configCollectionView];
}

- (void)configDataSource {
    [self.itemArray removeAllObjects];
    XDLiveChargeConfigModel *propertyModel = [[XDLiveChargeConfigModel alloc] init];
    propertyModel.title = @"物业费";
    propertyModel.imageName = @"pay_property";
    XDLiveChargeConfigModel *parkingModel = [[XDLiveChargeConfigModel alloc] init];
    parkingModel.title = @"停车缴费";
    parkingModel.imageName = @"pay_parking";
    XDLiveChargeConfigModel *waterModel = [[XDLiveChargeConfigModel alloc] init];
    waterModel.title = @"水费";
    waterModel.imageName = @"pay_water";
    XDLiveChargeConfigModel *elecModel = [[XDLiveChargeConfigModel alloc] init];
    elecModel.title = @"电费";
    elecModel.imageName = @"pay_elec";
    XDLiveChargeConfigModel *wifiModel = [[XDLiveChargeConfigModel alloc] init];
    wifiModel.title = @"宽带";
    wifiModel.imageName = @"pay_wifi";
    XDLiveChargeConfigModel *teleModel = [[XDLiveChargeConfigModel alloc] init];
    teleModel.title = @"固话";
    teleModel.imageName = @"pay_tele";
    XDLiveChargeConfigModel *gasModel = [[XDLiveChargeConfigModel alloc] init];
    gasModel.title = @"物业费";
    gasModel.imageName = @"pay_gas";
    XDLiveChargeConfigModel *tvModel = [[XDLiveChargeConfigModel alloc] init];
    tvModel.title = @"有线电视";
    tvModel.imageName = @"pay_tv";
    self.itemArray = [NSMutableArray arrayWithObjects:propertyModel, parkingModel, waterModel, elecModel, wifiModel, teleModel, gasModel, tvModel, nil];
}

- (void)configCollectionView {
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavHeight - TabbarHeight) collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = litterBackColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"XDLiveChargeCell" bundle:NSBundle.mainBundle] forCellWithReuseIdentifier:@"XDLiveChargeCell"];
}

#pragma mark - uicollection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 3 * kMargin)/ 3.f, (kScreenWidth - 3 * kMargin)/ 3.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDLiveChargeConfigModel *model = self.itemArray[indexPath.row];
    XDLiveChargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDLiveChargeCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = model.title;
    cell.iconImageView.image = [UIImage imageNamed:model.imageName];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDLiveChargeConfigModel *model = self.itemArray[indexPath.row];
    NSString *notOpen = @"暂未集成，敬请期待";
    if ([model.title isEqualToString:@"物业费"]) {
        [XDUtil showToast:notOpen];
    } else if ([model.title isEqualToString:@"停车缴费"]) {
        XDParkPayController *parkVC = [[XDParkPayController alloc] init];
        [self.navigationController pushViewController:parkVC animated:YES];
    } else if ([model.title isEqualToString:@"水费"]) {
        JXBWebViewController *detailVC = [[JXBWebViewController alloc] initWithURLString:WaterPayUrl];
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if ([model.title isEqualToString:@"电费"]) {
        JXBWebViewController *detailVC = [[JXBWebViewController alloc] initWithURLString:ElectricityPayUrl];
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if ([model.title isEqualToString:@"宽带"]) {
        [XDUtil showToast:notOpen];
    } else if ([model.title isEqualToString:@"固话"]) {
        [XDUtil showToast:notOpen];
    } else if ([model.title isEqualToString:@"物业费"]) {
        [XDUtil showToast:notOpen];
    } else if ([model.title isEqualToString:@"有线电视"]) {
        [XDUtil showToast:notOpen];
    }
}

#pragma mark - lazy load
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end
