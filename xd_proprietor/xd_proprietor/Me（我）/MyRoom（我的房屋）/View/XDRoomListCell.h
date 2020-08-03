//
//  Created by cfsc on 2020/3/12.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDRoomModel;
NS_ASSUME_NONNULL_BEGIN

@interface XDRoomListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *roomStateView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

- (void)setContentWithModel:(XDRoomModel *)roomModel;

@end

NS_ASSUME_NONNULL_END
