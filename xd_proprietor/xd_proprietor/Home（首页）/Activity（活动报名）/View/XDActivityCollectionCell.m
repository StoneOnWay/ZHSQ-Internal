//
//  Created by cfsc on 2020/6/12.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDActivityCollectionCell.h"
#import "XDActivityModel.h"

@implementation XDActivityCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 10.0f;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = BianKuang.CGColor;
    self.contentView.layer.masksToBounds = YES;
    // 阴影颜色
    self.layer.shadowColor = BianKuang.CGColor;
    // 阴影偏移，默认(0, -3)
    self.layer.shadowOffset = CGSizeMake(1, 3);
    // 阴影透明度，默认0
    self.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    self.layer.shadowRadius = 3;
    self.layer.masksToBounds = NO;
    
    self.isEnrollLabel.layer.cornerRadius = 15.f;
    self.isEnrollLabel.layer.borderColor = BianKuang.CGColor;
    self.isEnrollLabel.layer.borderWidth = 1.f;
}

- (void)setActivity:(XDActivityModel *)activity {
    _activity = activity;
    UIColor *forbidColor = [UIColor colorWithHexString:@"fe552e"];
    UIColor *enrollColor = [UIColor colorWithHexString:@"13AD57"];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:activity.coverImageResource.url] placeholderImage:[UIImage imageNamed:@"project_cell_back"]];
    self.titleLabel.text = activity.title;
    self.locationLabel.text = activity.location;
    self.deadLineLabel.text = activity.registrationDeadline;
    self.enrollNumberLabel.text = activity.enrollmentNumber;
    if (!activity.isParticipate) {
        self.isEnrollLabel.text = @"去参加";
        self.isEnrollLabel.textColor = forbidColor;
    } else if (activity.isParticipate) {
        self.isEnrollLabel.text = @"已报名";
        self.isEnrollLabel.textColor = enrollColor;
    }
    // 开始时间
    NSArray *array = [activity.startTime componentsSeparatedByString:@"-"];
    if (array.count == 3) {
        NSString *month = array[1];
        self.startMonthLabel.text = [self monthChange:month];
        self.startDayLabel.text = array[2];
    }
}

- (NSString *)monthChange:(NSString *)month {
    NSDictionary *dic = @{
        @"01":@"一月",
        @"02":@"二月",
        @"03":@"三月",
        @"04":@"四月",
        @"05":@"五月",
        @"06":@"六月",
        @"07":@"七月",
        @"08":@"八月",
        @"09":@"九月",
        @"10":@"十月",
        @"11":@"十一月",
        @"12":@"十二月",
    };
    return dic[month];
}

@end
