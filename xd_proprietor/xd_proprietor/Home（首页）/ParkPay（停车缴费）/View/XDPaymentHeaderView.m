//
//  XDPaymentHeaderView.m
//  xd_proprietor
//
//  Created by stone on 29/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDPaymentHeaderView.h"

@implementation XDPaymentHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] firstObject];
    }
    return self;
}

@end
