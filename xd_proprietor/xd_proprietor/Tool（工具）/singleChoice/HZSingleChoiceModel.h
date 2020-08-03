//
//  HZSingleChoiceModel.h
//  Pods
//
//  Created by mason on 2017/8/5.
//
//

#import <Foundation/Foundation.h>
//#import "HZTypeModel.h"

@interface HZSingleChoiceModel : NSObject

/** 基础数据类型 */
//@property (strong, nonatomic) HZTypeModel *typeModel;

/** 内容 */
@property (strong, nonatomic) NSString *title;

/** 编码 */
@property (strong, nonatomic) NSString *typeCode;

/** 是否选中 */
@property (assign, nonatomic, getter = isSelectedStatus) BOOL selectedStatus;

@end
