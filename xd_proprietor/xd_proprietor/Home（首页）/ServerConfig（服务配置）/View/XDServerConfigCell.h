//
//  Created by cfsc on 2020/7/13.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDServerConfigCellModel.h"

@class XDServerConfigCellModel;

@interface XDServerConfigCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) XDServerConfigCellModel *data;

- (void)resetModel:(XDServerConfigCellModel *)data :(NSIndexPath *)indexPath;

@end
