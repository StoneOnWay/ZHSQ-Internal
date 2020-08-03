//
//  HZBaseAddImageItemCollectionViewCell.h
//  Pods
//
//  Created by mason on 2017/8/2.
//
//

#import <UIKit/UIKit.h>
#import "HZBaseAddImageTableViewCell.h"

@interface HZBaseAddImageItemCollectionViewCell : UICollectionViewCell

/** <##> */
@property (strong, nonatomic) HZBaseImageModel *baseImageModel;
/** <##> */
@property (assign, nonatomic) NSInteger index;
/** 删除block */
@property (copy, nonatomic) void(^deleteItemBlock)(HZBaseImageModel *baseImageModel);


@end
