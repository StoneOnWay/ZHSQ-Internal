//
//  Created by cfsc on 2020/3/2.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@class XDFlowProcessModel;

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowDetailCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *solutionView;
@property (weak, nonatomic) IBOutlet UILabel *solutionLabel;
@property (weak, nonatomic) IBOutlet UIView *remarkView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIView *expectedTimeView;
@property (weak, nonatomic) IBOutlet UILabel *expectedTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;
@property (weak, nonatomic) IBOutlet UIView *resourceView;
@property (weak, nonatomic) IBOutlet UICollectionView *resourceCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *solutionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expectedTimeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resouceViewHeightConstriant;

@property (weak, nonatomic) IBOutlet UILabel *nodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (nonatomic, strong) XDFlowProcessModel *processModel;

+ (CGFloat)heightWithProcess:(XDFlowProcessModel *)processModel;

@end

NS_ASSUME_NONNULL_END
