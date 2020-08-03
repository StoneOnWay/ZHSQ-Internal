//
//  Created by cfsc on 2020/3/21.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDOperationTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *upfoldBtn;
@property (nonatomic, copy) void (^upfoldBlock)(void);
@property (nonatomic, copy) void (^foldBlock)(void);
@end

NS_ASSUME_NONNULL_END
