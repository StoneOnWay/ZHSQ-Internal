//
//  Created by cfsc on 2020/6/15.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDCollectionActivityHeaderReusableView.h"

@implementation XDCollectionActivityHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)getMoreAction:(id)sender {
    if (self.getMoreAction) {
        self.getMoreAction();
    }
}

@end
