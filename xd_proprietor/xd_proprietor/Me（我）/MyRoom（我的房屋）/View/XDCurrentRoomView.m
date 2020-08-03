//
//  Created by cfsc on 2020/3/16.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDCurrentRoomView.h"

@implementation XDCurrentRoomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.backView.layer.cornerRadius = 8.f;
    self.backView.layer.masksToBounds = YES;
}

- (void)setRoomModel:(XDRoomModel *)roomModel {
    _roomModel = roomModel;
    self.projectNameLabel.text = roomModel.projectName;
    self.fullNameLabel.text = roomModel.fullName;
    self.roomCodeLabel.text = roomModel.code;
    self.roomCodeLabel.hidden = NO;
    self.separatorView.hidden = NO;
    self.codeTitlelabel.hidden = NO;
}

- (void)setProjectName:(NSString *)projectName {
    _projectName = projectName;
    self.projectNameLabel.text = projectName;
    self.fullNameLabel.text = @"物业中心";
    self.roomCodeLabel.hidden = YES;
    self.separatorView.hidden = YES;
    self.codeTitlelabel.hidden = YES;
}

@end
