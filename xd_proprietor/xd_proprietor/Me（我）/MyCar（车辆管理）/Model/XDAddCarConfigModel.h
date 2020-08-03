//
//  XDAddCarConfigModel.h
//  xd_proprietor
//
//  Created by stone on 21/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZCarPlateNoTextField.h"

typedef NS_ENUM(NSInteger, CarPropertyType) {
    CarPropertyTypePlateNo,
    CarPropertyTypePhoto,
    CarPropertyTypeCharter,
    CarPropertyTypeOther
};

NS_ASSUME_NONNULL_BEGIN

@interface XDAddCarConfigModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) CarPropertyType type;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray <RZCarPlateNoTextField *> *textFields;

@end

NS_ASSUME_NONNULL_END
