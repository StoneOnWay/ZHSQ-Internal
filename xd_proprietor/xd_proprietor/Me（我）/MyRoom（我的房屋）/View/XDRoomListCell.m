//
//  Created by cfsc on 2020/3/12.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDRoomListCell.h"
#import "XDRoomModel.h"

@implementation XDRoomListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.roomStateView.layer.cornerRadius = 5.f;
    self.roomStateView.layer.masksToBounds = YES;
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setContentWithModel:(XDRoomModel *)roomModel {
    self.roomNameLabel.text = roomModel.fullName;
    self.projectNameLabel.text = roomModel.projectName;
    self.rightImageView.hidden = NO;
    // 提交审核的房间
    if (roomModel.approvalStatus == 1) {
        self.stateLabel.text = @"等待审核";
        self.roomStateView.backgroundColor = [UIColor lightGrayColor];
        self.rightImageView.hidden = YES;
    } else if (roomModel.approvalStatus == 3) {
        self.stateLabel.text = @"审核被拒";
        self.roomStateView.backgroundColor = [UIColor lightGrayColor];
        self.rightImageView.hidden = YES;
    } else {
        self.stateLabel.text = roomModel.householdTypeDisplay;
        self.roomStateView.backgroundColor = RGB(19, 173, 87);
    }
}

@end
