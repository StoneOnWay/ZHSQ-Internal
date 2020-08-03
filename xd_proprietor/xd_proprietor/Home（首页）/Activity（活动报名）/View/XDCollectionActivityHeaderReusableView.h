//
//  Created by cfsc on 2020/6/15.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDCollectionActivityHeaderReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) void (^getMoreAction)(void);
@end

NS_ASSUME_NONNULL_END
