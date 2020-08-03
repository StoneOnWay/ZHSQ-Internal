//
//  XDSettingCell.h
//  xd_proprietor
//
//  Created by stone on 15/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XDSettingsConfigModel;
@interface XDSettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, strong) XDSettingsConfigModel *configModel;

@end

NS_ASSUME_NONNULL_END
