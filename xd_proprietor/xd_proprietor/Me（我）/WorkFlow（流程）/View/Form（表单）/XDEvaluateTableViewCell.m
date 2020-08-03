//
//  XDEvaluateTableViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/10.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDEvaluateTableViewCell.h"
#import "HCSStarRatingView.h"

@interface XDEvaluateTableViewCell()

@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;

@end

@implementation XDEvaluateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    [self.starRatingView addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[HCSStarRatingView class]]) {
        if (self.textBlock) {
            HCSStarRatingView *starRatinView = (HCSStarRatingView *)object;
            NSString *text = [NSString stringWithFormat:@"%.0f", starRatinView.value];
            self.textBlock(text);
        }
    }
}

- (void)dealloc {
    [self.starRatingView removeObserver:self forKeyPath:@"value"];
}

@end
