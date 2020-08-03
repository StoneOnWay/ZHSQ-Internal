//
//  UIStoryboard+Addition.h
//  GGCommonKit
//
//  Created by Ron on 14-3-22.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import <UIKit/UIStoryboard.h>

@interface UIStoryboard(Addition)

+ (UIStoryboard*)fromName:(NSString*)name;

+ (UIStoryboard*)fromName:(NSString*)name bundle:(NSBundle *)bundle;

@end
