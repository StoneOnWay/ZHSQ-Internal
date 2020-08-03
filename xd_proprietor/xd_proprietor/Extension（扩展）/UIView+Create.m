//
//  UIView+Create.m
//  NissanApp
//
//  Created by Ron on 14-3-22.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import "UIView+Create.h"

@implementation UIView(Create)

+ (id)loadFromNib
{
    return [self loadFromNibWithBandle:[NSBundle mainBundle]];
}
    
+ (id)loadFromNibWithBandle:(NSBundle *)bandle {
    NSString *xibName = NSStringFromClass([self class]);
    return [[bandle loadNibNamed:xibName owner:nil options:nil] firstObject];
}

@end
