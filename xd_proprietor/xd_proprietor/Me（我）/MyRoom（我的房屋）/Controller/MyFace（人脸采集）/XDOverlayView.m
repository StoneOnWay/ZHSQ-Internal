//
//  XDOverlayView.m
//  xd_proprietor
//
//  Created by stone on 16/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDOverlayView.h"

@implementation XDOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.takePhotoBtn.hidden = NO;
    self.cancelBtn.hidden = NO;
    self.photoImageView.hidden = YES;
}

- (IBAction)takePhoto:(id)sender {
    [self.picker takePicture];
    self.takePhotoBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
}

- (IBAction)cancel:(id)sender {
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(id)sender {
    self.takePhotoBtn.hidden = NO;
    self.cancelBtn.hidden = NO;
    self.photoImageView.hidden = YES;
}

- (IBAction)select:(id)sender {
    if ([self.delegate respondsToSelector:@selector(overlayDidSelect)]) {
        [self.delegate overlayDidSelect];
    }
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

@end
