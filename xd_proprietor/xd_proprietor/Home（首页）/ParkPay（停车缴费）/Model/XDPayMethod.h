//
//  XDPayMethod.h
//  xd_proprietor
//
//  Created by stone on 28/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDPayMethod : NSObject
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, assign) BOOL isRecommend;
@end

NS_ASSUME_NONNULL_END
