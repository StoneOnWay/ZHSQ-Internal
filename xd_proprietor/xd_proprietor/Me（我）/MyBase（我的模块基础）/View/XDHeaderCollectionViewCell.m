//
//  Created by cfsc on 2020/3/4.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDHeaderCollectionViewCell.h"

@interface XDHeaderCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation XDHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headerImageView.layer setCornerRadius:self.headerImageView.width / 2.f];
    [self.headerImageView.layer setMasksToBounds:YES];
    [self.headerImageView.layer setBorderWidth:2.f];
    [self.headerImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)setContent {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *roomStr = [NSString stringWithFormat:@"%@%@%@", loginInfo.userModel.currentDistrict.phaseName, loginInfo.userModel.currentDistrict.buildingName, loginInfo.userModel.currentDistrict.roomName];
    roomStr = [roomStr stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    self.idLab.text = [roomStr isEqualToString:@""] ? @"未绑定房屋" : roomStr;
    self.nameLab.text = loginInfo.userModel.nickName ? loginInfo.userModel.nickName : @"用户";
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:loginInfo.userModel.avatarResource.url] placeholderImage:[UIImage imageNamed:@"wode_touxiang"]];
}

@end
