//
//  XDPayMethodCell.h
//  xd_proprietor
//
//  Created by stone on 28/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDPayMethod;
NS_ASSUME_NONNULL_BEGIN
@interface XDPayMethodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipsImageView;

- (void)setContentWithPayModel:(XDPayMethod *)method;
@end

NS_ASSUME_NONNULL_END
