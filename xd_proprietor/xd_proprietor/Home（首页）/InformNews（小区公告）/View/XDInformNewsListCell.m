//
//  XDInformNewsListCell.m
//  XD业主
//
//  Created by zc on 2017/6/24.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDInformNewsListCell.h"
#import "UIImageView+WebCache.h"

@implementation XDInformNewsListCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDInformNewsListCell";
    XDInformNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDInformNewsListCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
    
}

- (void)setIconImageUrl:(NSString *)iconImageUrl {
    
    _iconImageUrl = iconImageUrl;
    NSString *stringUrl = [NSString stringWithFormat:@"%@", iconImageUrl];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:stringUrl] placeholderImage:[UIImage imageNamed:@"xqgg_pic_0"] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
        
    

}

@end
