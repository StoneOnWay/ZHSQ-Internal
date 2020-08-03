//
//  HZBaseListInfoTableViewCell.h
//  Pods
//
//  Created by mason on 2017/7/31.
//
//

#import <UIKit/UIKit.h>
#import "HZBaseModel.h"

@protocol HZBaseListInfoTableViewCellDelegate <NSObject>

@optional
- (void)didSelectedItemWithBaseModel:(HZBaseModel *)baseModel;
- (void)lookMapPath;
- (void)makePhone;
- (void)sendMesInfo;

@end

@interface HZBaseListInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) HZBaseModel *baseModel;
@property (weak, nonatomic) id<HZBaseListInfoTableViewCellDelegate>delegate;

@property (copy, nonatomic) void(^inputContentChangeBlock)(NSString *content);


@end
