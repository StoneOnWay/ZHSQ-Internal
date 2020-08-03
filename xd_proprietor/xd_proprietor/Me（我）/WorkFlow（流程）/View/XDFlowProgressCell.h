//
//  Created by cfsc on 2020/4/26.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDFlowProcessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowProgressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nodeNameLabel;
@property (strong, nonatomic) XDFlowProcessModel *processModel;

@end

NS_ASSUME_NONNULL_END
