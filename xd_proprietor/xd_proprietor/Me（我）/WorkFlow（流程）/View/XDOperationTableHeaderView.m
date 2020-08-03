//
//  Created by cfsc on 2020/3/21.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDOperationTableHeaderView.h"

@implementation XDOperationTableHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(XDOperationTableHeaderView.class) owner:nil options:nil] lastObject];
    }
    return self;
}

- (IBAction)upfoldAciton:(UIButton *)sender {
    if (sender.selected) {
        if (self.foldBlock) {
            self.foldBlock();
        }
    } else {
        if (self.upfoldBlock) {
            self.upfoldBlock();
        }
    }
    sender.selected = !sender.selected;
}
@end
