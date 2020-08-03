//
//  Created by cfsc on 2020/3/28.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDEventTableView.h"

@implementation XDEventTableView

//// 点击的是tableview就结束编辑并且返回tableview本身，这样就不影响了tableview本身的操作，然后点击的是tableview的子视图的时候就返回子视图
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    id view = [super hitTest:point withEvent:event];
//    if (!([view isKindOfClass:UITextView.class] || [view isKindOfClass:UITextField.class] || [view isKindOfClass:UIButton.class] || [view isKindOfClass:self.class])) {
//        [self endEditing:YES];
//        return self;
//    } else {
//        return view;
//    }
//}

@end
