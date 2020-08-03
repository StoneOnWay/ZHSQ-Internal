//
//  XDMarqueeCollectionViewCell.h
//  xd_proprietor
//
//  Created by mason on 2018/9/3.
//Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDHomeMenuModel.h"
#import "MHMarqueeView.h"

@interface XDMarqueeCollectionViewCell : UICollectionViewCell

/** <##> */
@property (strong, nonatomic) XDHomeMenuModel *homeMenuModel;
@property (strong, nonatomic) MHMarqueeView *marquee;
- (void)setAllDataWithArr:(NSArray*)arr;

@end
