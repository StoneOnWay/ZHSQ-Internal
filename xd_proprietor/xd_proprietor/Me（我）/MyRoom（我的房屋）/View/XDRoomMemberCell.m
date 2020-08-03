//
//  Created by cfsc on 2020/3/16.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDRoomMemberCell.h"

@implementation XDRoomMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius = 25.f;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setContentWithUser:(XDUserModel *)userModel {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatarResource.url] placeholderImage:[UIImage imageNamed:@"tsxq2_user"]];
    self.nameLabel.text = userModel.name;
    self.typeLabel.text = userModel.householdTypeDisplay;
}

@end
