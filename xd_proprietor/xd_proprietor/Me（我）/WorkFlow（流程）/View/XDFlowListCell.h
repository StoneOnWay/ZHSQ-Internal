//
//  Created by cfsc on 2020/2/26.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDFlowModel;

NS_ASSUME_NONNULL_BEGIN

@interface XDFlowListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setContentWithFlowModel:(XDFlowModel *)flow;

@end

NS_ASSUME_NONNULL_END
