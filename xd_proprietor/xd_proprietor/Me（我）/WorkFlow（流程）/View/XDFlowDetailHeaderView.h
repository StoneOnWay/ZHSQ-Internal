//
//  Created by cfsc on 2020/3/2.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDFlowDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface XDFlowDetailHeaderView : UITableViewHeaderFooterView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *holderLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UICollectionView *resourceCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resourceViewHeightConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeightConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressTopConstaint;
@property (weak, nonatomic) IBOutlet UILabel *typeKeyLabel;
@property (nonatomic, strong) XDFlowDetailModel *model;

+ (CGFloat)heigtForViewWithFlowDetail:(XDFlowDetailModel *)flowDetail;
@end

NS_ASSUME_NONNULL_END
