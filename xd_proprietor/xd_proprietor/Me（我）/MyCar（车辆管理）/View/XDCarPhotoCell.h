//
//  XDCarPhotoCell.h
//  xd_proprietor
//
//  Created by stone on 23/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XDAddCarConfigModel;
@interface XDCarPhotoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) XDAddCarConfigModel *model;
@property (nonatomic, copy) void (^addCarPhoto)(void);

- (IBAction)addAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
