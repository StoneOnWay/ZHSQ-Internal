//
//  HZBaseAddImageTableViewCell.m
//  Pods
//
//  Created by mason on 2017/8/2.
//
//

#import "HZBaseAddImageTableViewCell.h"
#import "HZBaseAddImageItemCollectionViewCell.h"

@implementation HZBaseImageModel

@end


@interface HZBaseAddImageTableViewCell()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HZBaseAddImageTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HZBaseAddImageItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HZBaseAddImageItemCollectionViewCell class])];
}

- (void)setItemArray:(NSArray *)itemArray {
    _itemArray = itemArray;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HZBaseAddImageItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HZBaseAddImageItemCollectionViewCell class]) forIndexPath:indexPath];
    cell.baseImageModel = self.itemArray[indexPath.row];
    @weakify(self)
    [cell setDeleteItemBlock:^(HZBaseImageModel *baseImageModel){
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(deleteItemWithImageModel:indexPath:)]) {
            [self.delegate deleteItemWithImageModel:baseImageModel indexPath:indexPath];
        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HZBaseImageModel *baseImageModel = self.itemArray[indexPath.row];
    if (baseImageModel.baseSourceType == HZBaseSourceTypeNone) {
        if ([self.delegate respondsToSelector:@selector(pickerPhoto:)]) {
            [self.delegate pickerPhoto:self];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kScreenWidth - 30.f - 3 * 3.f) / 4;
    CGFloat height = width;
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 3.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

+ (CGFloat)cellHeightWithTotalCount:(NSInteger)totalCount {
    CGFloat width = (kScreenWidth - 30.f - 2 * 3.f) / 3 - 1.f;
    CGFloat height = width * 150.f / 226.f;
    CGFloat totalHeight = 0;
    if (totalCount % 3 > 0) {
        totalHeight = 44.f + (totalCount / 3 + 1) * (height + 3) - 3;
    } else {
        totalHeight = 44.f + (totalCount / 3) * (height + 3) - 3;
    }
    return totalHeight;
}

@end
