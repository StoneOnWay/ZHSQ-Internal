//
//  XDCarPhotoCell.m
//  xd_proprietor
//
//  Created by stone on 23/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDCarPhotoCell.h"
#import "XDAddCarConfigModel.h"

@implementation XDCarPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(XDAddCarConfigModel *)model {
    _model = model;
    if (model.image) {
        self.photoImageView.image = model.image;
        self.addBtn.hidden = YES;
        return;
    }
    if (model.value) {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.value] placeholderImage:[UIImage imageNamed:@"load_fail"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            model.image = image;
        }];
        self.addBtn.hidden = YES;
    } else {
        self.addBtn.hidden = NO;
    }
}

- (IBAction)addAction:(UIButton *)sender {
    if (self.addCarPhoto) {
        self.addCarPhoto();
    }
}

@end
