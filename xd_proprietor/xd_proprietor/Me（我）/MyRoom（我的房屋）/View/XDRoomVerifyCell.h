//
//  Created by cfsc on 2020/3/12.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDVerifyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDRoomVerifyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *roomStateView;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (nonatomic, strong) XDVerifyModel *verifyModel;
@property (nonatomic, copy) void (^verifyCompleted)(void);

@end

NS_ASSUME_NONNULL_END
