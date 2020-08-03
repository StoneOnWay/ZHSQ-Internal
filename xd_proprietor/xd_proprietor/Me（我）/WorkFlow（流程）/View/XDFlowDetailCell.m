//
//  Created by cfsc on 2020/3/2.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDFlowDetailCell.h"
#import "XDFlowProcessModel.h"
#import "XDFlowResourceCollectionCell.h"
#import "XDResourceModel.h"
#import "JJPhotoManeger.h"

@implementation XDFlowDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.cornerRadius = 5.0f;
    // 阴影颜色
    self.backView.layer.shadowColor = [UIColor grayColor].CGColor;
    // 阴影偏移，默认(0, -3)
    self.backView.layer.shadowOffset = CGSizeMake(1, 1);
    // 阴影透明度，默认0
    self.backView.layer.shadowOpacity = 1;
    // 阴影半径，默认3
    self.backView.layer.shadowRadius = 3;
    
    self.headerImageView.layer.cornerRadius = 5;
    self.headerImageView.layer.masksToBounds = YES;
    
    self.resourceCollectionView.delegate = self;
    self.resourceCollectionView.dataSource = self;
    [self.resourceCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDFlowResourceCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDFlowResourceCollectionCell class])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)phoneAction:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", self.processModel.handlerMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)setProcessModel:(XDFlowProcessModel *)processModel {
    _processModel = processModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:processModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"tsxq2_user"]];
    self.creatorNameLabel.text = processModel.handlerName;
    self.descLabel.text = processModel.briefDesc;
    [self.phoneButton setTitle:processModel.handlerMobile forState:UIControlStateNormal];
    self.nodeLabel.text = processModel.nodeName;
    self.timeLabel.text = processModel.createTime;
    self.solutionViewHeightConstraint.constant = 0;
    self.remarkViewHeightConstraint.constant = 0;
    self.expectedTimeHeightConstraint.constant = 0;
    self.ratingViewHeightConstraint.constant = 0;
    self.resouceViewHeightConstriant.constant = 0;
    self.solutionView.hidden = YES;
    self.remarkView.hidden = YES;
    self.ratingView.hidden = YES;
    self.resourceView.hidden = YES;
    self.expectedTimeView.hidden = YES;
    if (processModel.remark) {
        self.remarkViewHeightConstraint.constant = [self.class heightForStr:processModel.remark] + 10;
        self.remarkView.hidden = NO;
        self.remarkLabel.text = processModel.remark;
    }
    if (processModel.content) {
        self.solutionViewHeightConstraint.constant = [self.class heightForStr:processModel.content] + 10;
        self.solutionView.hidden = NO;
        self.solutionLabel.text = processModel.content;
    }
    if (processModel.contentDate) {
        self.expectedTimeHeightConstraint.constant = 20 + 10;
        self.expectedTimeView.hidden = NO;
        self.expectedTimeLabel.text = processModel.contentDate;
    }
    if (processModel.commentLevel) {
        self.ratingViewHeightConstraint.constant = 25 + 10;
        self.ratingView.hidden = NO;
        self.starRatingView.value = processModel.commentLevel.integerValue;
    }
    if (processModel.resourceValue.count > 0) {
        self.resouceViewHeightConstriant.constant = [self.class collectionViewHeightWithCount:processModel.resourceValue.count] + 10;
        self.resourceView.hidden = NO;
    }
}

+ (CGFloat)collectionViewHeightWithCount:(NSInteger)count {
    // collection高度
    CGFloat oneRowHeight = (kScreenWidth - 20 * 2 - 10 *2 - 20 * 3) / 4 + 3;
    CGFloat collectionHeight = 0;
    if (count % 4 == 0) {
        collectionHeight = oneRowHeight * count/4;
    } else {
        collectionHeight = oneRowHeight * (count/4 + 1);
    }
//    NSLog(@"collecitonHeight -- %f", collectionHeight);
    return collectionHeight;
}

+ (CGFloat)heightWithProcess:(XDFlowProcessModel *)processModel {
    // remark高度
    CGFloat height = 115;
    if (processModel.remark) {
        height += [self heightForStr:processModel.remark] + 10;
    }
    if (processModel.content) {
        height += [self heightForStr:processModel.content] + 10;
    }
    if (processModel.contentDate) {
        height += 20 + 10;
    }
    if (processModel.commentLevel) {
        height += 25 + 10;
    }
    if (processModel.resourceValue.count > 0) {
        height += [self collectionViewHeightWithCount:processModel.resourceValue.count] + 10;
    }
    return height;
}

+ (CGFloat)heightForStr:(NSString *)str {
    CGFloat height = 0;
    CGFloat lableWidth = kScreenWidth - 20 * 2 - 10 - 5 - 71.5;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(lableWidth, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    height = rect.size.height;
    //    NSLog(@"remark height -- %f", height);
    return height;
}

#pragma mark - collectionViewDelegate && dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.processModel.resourceValue.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDResourceModel *model = self.processModel.resourceValue[indexPath.row];
    XDFlowResourceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDFlowResourceCollectionCell class]) forIndexPath:indexPath];
    [cell.resourceImageView setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@""]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat oneRowHeight = (kScreenWidth - 20 * 2 - 10 *2 - 20 * 3) / 4;
    return CGSizeMake(oneRowHeight, oneRowHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 3.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDFlowResourceCollectionCell *cell = (XDFlowResourceCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    [mg showLocalPhotoViewer:@[cell.resourceImageView] selecImageindex:0];
}


@end
