//
//  Created by cfsc on 2020/6/18.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDEquipmentModel;
NS_ASSUME_NONNULL_BEGIN

@interface XDRemoteOpenTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (nonatomic, strong) XDEquipmentModel *equipment;

@end

NS_ASSUME_NONNULL_END
