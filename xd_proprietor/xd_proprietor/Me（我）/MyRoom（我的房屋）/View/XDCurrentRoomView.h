//
//  Created by cfsc on 2020/3/16.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDCurrentRoomView : UIView

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeTitlelabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (nonatomic, strong) XDRoomModel *roomModel;
@property (nonatomic, copy) NSString *projectName;

@end

NS_ASSUME_NONNULL_END
