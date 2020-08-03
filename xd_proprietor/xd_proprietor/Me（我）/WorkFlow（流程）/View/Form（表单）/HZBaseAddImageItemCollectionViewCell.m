//
//  HZBaseAddImageItemCollectionViewCell.m
//  Pods
//
//  Created by mason on 2017/8/2.
//
//

#import "HZBaseAddImageItemCollectionViewCell.h"

@interface HZBaseAddImageItemCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
/** <##> */
@property (strong, nonatomic) UIButton *deleteButton;

@end

@implementation HZBaseAddImageItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.showImageView.layer.cornerRadius = 5.f;
//    self.showImageView.layer.masksToBounds = YES;
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"tousu_btn_close"] forState:UIControlStateNormal];
//    btn.frame = CGRectMake(self.width - 16.f, 0, 16.f, 16.f);
//    [btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn];
//    self.deleteButton = btn;
}

- (void)layoutSubviews {
//    self.deleteButton.frame = CGRectMake(self.width - 16.f, 0, 16.f, 16.f);
}

- (void)setBaseImageModel:(HZBaseImageModel *)baseImageModel {
    _baseImageModel = baseImageModel;
    if (baseImageModel.baseSourceType == HZBaseSourceTypeNormal) {
        self.deleteButton.hidden = NO;
        if ([baseImageModel.source isKindOfClass:[UIImage class]]) {
            self.showImageView.image = baseImageModel.source;
        } else if ([baseImageModel.source isKindOfClass:[NSString class]]){
//            [self.showImageView hz_setImageURL:kDefaultUrl placeholder:nil];
        } 
    } else if (baseImageModel.baseSourceType == HZBaseSourceTypeImageData) {
        self.deleteButton.hidden = NO;
        self.showImageView.image = [UIImage imageWithData:baseImageModel.source];
    } else if (baseImageModel.baseSourceType == HZBaseSourceTypeVideo) {
        self.deleteButton.hidden = NO;
//        [self.showImageView hz_setImageURL:kDefaultUrl placeholder:kPlaceholderImage];
    } else {
        self.deleteButton.hidden = YES;
        self.showImageView.image = [UIImage imageNamed:@"btn_public_add"];
    }
}
- (void)deleteAction:(UIButton *)sender {
    if (self.deleteItemBlock) {
        self.deleteItemBlock(self.baseImageModel);
    }
}

@end
