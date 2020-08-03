//
//  Created by cfsc on 2020/4/26.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDFlowProgressCell.h"

@implementation XDFlowProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setProcessModel:(XDFlowProcessModel *)processModel {
    _processModel = processModel;
    self.timeLabel.text = processModel.createTime;
    self.nodeNameLabel.text = processModel.nodeName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:processModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"tsxq2_user"]];
}

@end
