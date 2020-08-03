//
//  Created by cfsc on 2020/6/29.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDParticipatorTableCell.h"

@implementation XDParticipatorTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.cornerRadius = 5.0f;
    self.backView.layer.shadowColor = BianKuang.CGColor;
    // 阴影偏移，默认(0, -3)
    self.backView.layer.shadowOffset = CGSizeMake(1, 1);
    // 阴影透明度，默认0
    self.backView.layer.shadowOpacity = 1;
    // 阴影半径，默认3
    self.backView.layer.shadowRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setParticipator:(XDParticipatorModel *)participator {
    _participator = participator;
    self.ageLabel.text = participator.age;
    self.nameLabel.text = participator.name;
    self.phoneLabel.text = participator.mobile;
    if ([participator.gender isEqualToString:@"男"]) {
        self.genderImageView.image = [UIImage imageNamed:@"male"];
    } else if ([participator.gender isEqualToString:@"女"]) {
        self.genderImageView.image = [UIImage imageNamed:@"fmale"];
    }
}

- (IBAction)cancelAction:(id)sender {
    if (self.cancelRegist) {
        self.cancelRegist();
    }
}

@end
