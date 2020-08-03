//
//  XDInfoNewsToolBar.m
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDInfoNewsToolBar.h"

@implementation XDInfoNewsToolBar

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.zanBtn setImage:[UIImage imageNamed:@"ggxq_icon_zan_hui"] forState:UIControlStateNormal];
    [self.zanBtn setImage:[UIImage imageNamed:@"ggxq_icon_zan_p"] forState:UIControlStateSelected];
    self.backgroundColor = backColor;
    
    self.listBtn.layer.cornerRadius = 2;
    self.listBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.listBtn.layer.borderWidth = 1;
    [self.listBtn.layer setMasksToBounds:YES];
}

- (IBAction)shareBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickShareBtn:)]) {
        [self.delegate clickShareBtn:sender];
    }
}

- (IBAction)zanBtnClicked:(UIButton *)sender {
    NSInteger zanNum = self.zanLabel.text.integerValue;
    if (!sender.isSelected) {
        zanNum += 1;
    } else {
        zanNum -= 1;
    }
    self.zanLabel.text = [NSString stringWithFormat:@"%ld",(long)zanNum];
    if ([self.delegate respondsToSelector:@selector(clickZanBtn:)]) {
        [self.delegate clickZanBtn:sender];
    }
}

- (IBAction)commentBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickCommentBtn:)]) {
        [self.delegate clickCommentBtn:sender];
    }
}

- (IBAction)listBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickListBtn:)]) {
        [self.delegate clickListBtn:sender];
    }
}

@end
