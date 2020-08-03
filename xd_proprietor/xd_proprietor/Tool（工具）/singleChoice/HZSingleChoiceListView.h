//
//  HZSingleChoiceListView.h
//  Pods
//
//  Created by mason on 2017/8/5.
//
//

#import <UIKit/UIKit.h>
#import "HZSingleChoiceModel.h"

typedef void(^choiceDismissBlock)(void);
typedef void(^choiceResultBlock)(id result);

@interface HZSingleChoiceListView : UIView

/** <##> */
@property (copy, nonatomic) choiceDismissBlock choiceDismissBlock;

@property (copy, nonatomic) choiceResultBlock choiceResultBlock;
/** <##> */
@property (strong, nonatomic) NSArray *itemArray;
/** 是否多选<##> */
@property (assign, nonatomic, getter=isMultipleChoiceAbled) BOOL multipleChoiceAbled;

@end
