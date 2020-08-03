//
//  XDCarPropertyCell.h
//  xd_proprietor
//
//  Created by stone on 21/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XDAddCarConfigModel;
@interface XDCarPropertyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *necessaryTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, strong) XDAddCarConfigModel *model;

@end

NS_ASSUME_NONNULL_END
