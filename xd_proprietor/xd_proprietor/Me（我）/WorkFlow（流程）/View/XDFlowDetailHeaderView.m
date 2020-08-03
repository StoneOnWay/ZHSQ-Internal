//
//  Created by cfsc on 2020/3/2.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDFlowDetailHeaderView.h"
#import "XDFlowDetailModel.h"
#import "XDFlowResourceCollectionCell.h"
#import "JJPhotoManeger.h"
#import "XDResourceModel.h"

@implementation XDFlowDetailHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(XDFlowDetailHeaderView.class) owner:nil options:nil] lastObject];
        self.resourceCollectionView.delegate = self;
        self.resourceCollectionView.dataSource = self;
        [self.resourceCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDFlowResourceCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDFlowResourceCollectionCell class])];
        self.headerImageView.layer.cornerRadius = 5;
        self.headerImageView.layer.masksToBounds = YES;
    }
    return self;
}

+ (CGFloat)heigtForViewWithFlowDetail:(XDFlowDetailModel *)flowDetail {
    CGFloat height = 223;
    CGFloat lableWidth = kScreenWidth - 117;
    CGRect rect = [flowDetail.problemDesc boundingRectWithSize:CGSizeMake(lableWidth, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    if (![flowDetail.problemDesc isEqualToString:@""]) {
        height += rect.size.height;
    } else {
        height += 20;
    }
    if (flowDetail.problemResourceValue.count > 0) {
        height += [self collectionViewHeightWithCount:flowDetail.problemResourceValue.count] + 10;
    }
    return height;
}

+ (CGFloat)collectionViewHeightWithCount:(NSInteger)count {
    // collection高度
    CGFloat oneRowHeight = (kScreenWidth - 112) / 4;
    CGFloat collectionHeight = 0;
    if (count % 3 == 0) {
        collectionHeight = oneRowHeight * count/4;
        if (count / 4 > 1) {
            collectionHeight += 10;
        }
    } else {
        collectionHeight = oneRowHeight * (count/4 + 1);
        if (count / 4 > 0) {
            collectionHeight += 10;
        }
    }
    //    NSLog(@"collecitonHeight -- %f", collectionHeight);
    return collectionHeight;
}

- (void)setModel:(XDFlowDetailModel *)model {
    _model = model;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.creatorAvatarUrl] placeholderImage:[UIImage imageNamed:@"tsxq2_user"]];
    self.creatorNameLabel.text = model.createName;
    self.roomLabel.text = model.briefDesc;
    [self.phoneButton setTitle:(self.model.mobile ? self.model.mobile : self.model.householdMobile) forState:UIControlStateNormal];
    self.typeLabel.text = model.workTypeName;
    self.addressLabel.text = model.address ? model.address : [[NSString stringWithFormat:@"%@ %@ %@", model.projectName, model.phaseName, model.briefDesc] stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    self.holderLabel.text = self.model.linkMan ? self.model.linkMan : self.model.householdName;
    self.descLabel.text = model.problemDesc;
    self.timeLabel.text = model.createTime;
    // 投诉
    if ([model.flowType isEqualToString:@"2"]) {
        self.typeLabel.text = model.complaintTypeName;
        self.typeKeyLabel.text = @"投诉类型：";
        self.addressTopConstaint.constant = 0;
        self.addressHeightConstaint.constant = 0;
        [self layoutIfNeeded];
    }
    self.resourceCollectionView.hidden = YES;
    self.resourceViewHeightConstaint.constant = 0;
    if (model.problemResourceValue.count > 0) {
        self.resourceCollectionView.hidden = NO;
        self.resourceViewHeightConstaint.constant = [self.class collectionViewHeightWithCount:model.problemResourceValue.count] + 10;
    }
}

- (IBAction)phoneAction:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", self.model.mobile ? self.model.mobile : self.model.householdMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - collectionViewDelegate && dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.problemResourceValue.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDResourceModel *model = self.model.problemResourceValue[indexPath.row];
    XDFlowResourceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDFlowResourceCollectionCell class]) forIndexPath:indexPath];
    [cell.resourceImageView setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@""]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat oneRowHeight = (kScreenWidth - 112) / 4;
    return CGSizeMake(oneRowHeight, oneRowHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 3.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDFlowResourceCollectionCell *cell = (XDFlowResourceCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    [mg showLocalPhotoViewer:@[cell.resourceImageView] selecImageindex:0];
}


@end
