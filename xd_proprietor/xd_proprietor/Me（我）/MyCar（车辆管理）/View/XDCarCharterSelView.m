//
//  XDCarCharterSelView.m
//  xd_proprietor
//
//  Created by cfsc on 2019/6/17.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDCarCharterSelView.h"

@implementation XDCarCharterSelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] firstObject];
    }
    return self;
}

+ (XDCarCharterSelView *)createCarCharterSelView {
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] firstObject];
}

- (IBAction)charterInfoAction:(UIButton *)sender {
    if (self.charterViewClick) {
        self.charterViewClick(sender.tag);
    }
}

@end
