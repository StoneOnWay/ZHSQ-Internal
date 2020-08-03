//
//  Created by cfsc on 2020/6/29.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDParticipatorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDParticipatorTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (nonatomic, strong) XDParticipatorModel *participator;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, copy) void (^cancelRegist)(void);

@end

NS_ASSUME_NONNULL_END
