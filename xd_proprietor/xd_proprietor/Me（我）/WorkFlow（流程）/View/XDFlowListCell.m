//
//  Created by cfsc on 2020/2/26.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDFlowListCell.h"
#import "XDFlowModel.h"

@implementation XDFlowListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setContentWithFlowModel:(XDFlowModel *)flow {
    self.typeLabel.text = flow.typeName;
    self.statusLabel.text = flow.statusName;
    self.descLabel.text = flow.problemDesc;
    self.infoLabel.text = flow.address ? flow.address : flow.briefDesc;
    self.timeLabel.text = flow.createTime;
    XDResourceModel *resource = flow.problemResourceValue.firstObject;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:resource.url] placeholderImage:[UIImage imageNamed:@"pic_find_1"]];
}

@end
