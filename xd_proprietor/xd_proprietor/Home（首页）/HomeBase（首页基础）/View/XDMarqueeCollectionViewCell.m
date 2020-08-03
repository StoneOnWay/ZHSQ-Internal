//
//  XDMarqueeCollectionViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/3.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDMarqueeCollectionViewCell.h"
#import "XDContentInfoModel.h"

@interface XDMarqueeCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *marqueeView;

@end

@implementation XDMarqueeCollectionViewCell
@synthesize marquee;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    marquee = [[MHMarqueeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 78.f, 55.f) lineNumber:1];
    marquee.backgroundColor = UIColorHex(f3f3f3);
    marquee.textColor = UIColorHex(787878);
    marquee.fontSize = 14.f;
    marquee.textAlignment = NSTextAlignmentLeft;
    [self.marqueeView addSubview:marquee];
}

- (void)setAllDataWithArr:(NSArray*)arr{
    NSMutableArray *nameArray = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(XDContentInfoModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameArray addObject:obj.title];
    }];
    marquee.dataSource = nameArray;
    marquee.currentIndex = 0;
}
@end
