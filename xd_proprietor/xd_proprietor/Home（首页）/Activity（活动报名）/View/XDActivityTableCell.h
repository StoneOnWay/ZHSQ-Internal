//
//  Created by cfsc on 2020/6/15.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDActivityModel;
NS_ASSUME_NONNULL_BEGIN

@interface XDActivityTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *startDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *startMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *enrollNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *isEnrollLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *isEnrollLabelWidthContraint;

@property (nonatomic, strong) XDActivityModel *activity;
@end

NS_ASSUME_NONNULL_END
