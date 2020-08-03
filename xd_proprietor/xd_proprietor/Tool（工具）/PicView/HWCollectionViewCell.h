//
//  HWCollectionViewCell.h
//  PhotoSelector
//
//  Created by hw on 2017/1/12.
//  Copyright © 2017年 hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *plusImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plusW;

@property(nonatomic,strong) UIImageView *BigImageView;

/** 查看大图 */
- (void)setBigImageViewWithImage:(UIImage *)image;
@end
