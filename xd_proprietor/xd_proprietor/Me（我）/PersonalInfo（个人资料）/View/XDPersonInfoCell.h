//
//  XDPersonInfoCell.h
//  xd_proprietor
//
//  Created by stone on 14/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XDPersonalConfigModel;
@interface XDPersonInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleTrailingConstraint;

@property (nonatomic, strong) XDPersonalConfigModel *personInfo;

@end

NS_ASSUME_NONNULL_END
