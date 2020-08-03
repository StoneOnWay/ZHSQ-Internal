//
//  HZBaseAddImageTableViewCell.h
//  Pods
//
//  Created by mason on 2017/8/2.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HZBaseSourceType) {
    HZBaseSourceTypeNone,
    HZBaseSourceTypeNormal,
    HZBaseSourceTypeVideo,
    HZBaseSourceTypeImageData
};

@interface HZBaseImageModel : NSObject

/** 图片资源或者Url */
@property (strong, nonatomic) id source;

/** 图片类型：  */
@property (assign, nonatomic) HZBaseSourceType baseSourceType;
@end


@protocol HZBaseAddImageTableViewCellDelegate <NSObject>

- (void)deleteItemWithImageModel:(HZBaseImageModel *)imageModel indexPath:(NSIndexPath *)indexPath;
- (void)pickerPhoto:(UIView *)view;

@end

@interface HZBaseAddImageTableViewCell : UITableViewCell

@property (strong, nonatomic) NSArray *itemArray;
@property (weak, nonatomic) id<HZBaseAddImageTableViewCellDelegate>delegate;

+ (CGFloat)cellHeightWithTotalCount:(NSInteger)totalCount;

@end
