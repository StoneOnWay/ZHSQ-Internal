//
//  CTCPlayerView.m
//  CommunityCloud
//
//  Created by shilei on 17/11/22.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "Masonry.h"
#import "CTCPlayerView.h"

@interface CTCPlayerView ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation CTCPlayerView
#pragma mark - ===============Life Cycle=============
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}
#pragma mark - ===============Init UI   =============
- (void)setupViews {
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.activityIndicatorView];
    
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}
#pragma mark - ===============Override Method =======

#pragma mark - ===============Net  Working ==========
#pragma mark - ===============Private Actions   =====

-(void)startloading {
    [self.activityIndicatorView startAnimating];
}

-(void)endloading {
    [self.activityIndicatorView stopAnimating];
}

#pragma mark - ===============Setter and Getter======
-(UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}

@end
