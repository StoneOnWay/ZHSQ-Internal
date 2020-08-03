//
//  Created by cfsc on 2020/6/12.
//  Copyright © 2020 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDActivityCell : UICollectionViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *activityCollectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void (^didSelectIndex)(NSIndexPath *);

@end

NS_ASSUME_NONNULL_END
