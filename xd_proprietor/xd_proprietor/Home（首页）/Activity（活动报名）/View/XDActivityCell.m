//
//  Created by cfsc on 2020/6/12.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDActivityCell.h"
#import "XDActivityCollectionCell.h"
#import "XDActivityModel.h"
#import "UICollectionViewLeftAlignedLayout.h"

@implementation XDActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.activityCollectionView.delegate = self;
    self.activityCollectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.activityCollectionView.collectionViewLayout = layout;
    self.activityCollectionView.showsHorizontalScrollIndicator = NO;
    [self.activityCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDActivityCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDActivityCollectionCell class])];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.activityCollectionView reloadData];
}

#pragma mark - collectionViewDelegate && dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDActivityModel *model = self.dataArray[indexPath.row];
    XDActivityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDActivityCollectionCell class]) forIndexPath:indexPath];
    cell.activity = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 300.f * (kScreenWidth - 10) / (414.f - 10);
    CGFloat height = width * 105 / 300 + 90 + 50;
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectIndex) {
        self.didSelectIndex(indexPath);
    }
}


@end
