//
//  XDOverlayView.h
//  xd_proprietor
//
//  Created by stone on 16/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDOverlayViewDelegate <NSObject>

- (void)overlayDidSelect;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XDOverlayView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic,weak) id<XDOverlayViewDelegate> delegate;

@property (nonatomic, strong) UIImagePickerController *picker;
@end

NS_ASSUME_NONNULL_END
