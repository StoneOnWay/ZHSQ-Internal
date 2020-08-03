//
//  XDCarListCell.h
//  xd_proprietor
//
//  Created by stone on 22/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XDVehicleModel;
@interface XDCarListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *plateNoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkingImageView;
@property (weak, nonatomic) IBOutlet UILabel *plateColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *plateTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *charterLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charterLabelWidthContraints;

@property (nonatomic, strong) XDVehicleModel *vehicleModel;

@end

NS_ASSUME_NONNULL_END
