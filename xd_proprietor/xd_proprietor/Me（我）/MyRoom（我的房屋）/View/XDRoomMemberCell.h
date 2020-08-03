//
//  Created by cfsc on 2020/3/16.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDRoomMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

- (void)setContentWithUser:(XDUserModel *)userModel;

@end

NS_ASSUME_NONNULL_END
