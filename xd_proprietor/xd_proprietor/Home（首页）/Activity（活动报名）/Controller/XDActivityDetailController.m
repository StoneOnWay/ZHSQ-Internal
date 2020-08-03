//
//  Created by cfsc on 2020/6/16.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDActivityDetailController.h"
#import "XDParticipatorListController.h"

@interface XDActivityDetailController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *enrollNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactorLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadLineLabel;
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeightConstraint;

@end

@implementation XDActivityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动详情";
    self.footerBtn.layer.cornerRadius = 25.f;
    self.footerBtn.layer.masksToBounds = YES;
    if ([self.activity.isEnd boolValue]) {
        self.footerBtn.enabled = NO;
        self.footerBtn.backgroundColor = RGB(210, 210, 210);
    } else {
        self.footerBtn.enabled = YES;
        self.footerBtn.backgroundColor = buttonColor;
    }
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.activity.coverImageResource.url] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLabel.text = self.activity.title;
    self.startTimeLabel.text = self.activity.startTime;
    self.endTimeLabel.text = self.activity.endTime;
    self.locationLabel.text = self.activity.location;
    self.enrollNumLabel.text = self.activity.enrollmentNumber;
    self.costLabel.text = self.activity.activityCosts;
    self.contactorLabel.text = self.activity.contactPerson;
    self.phoneLabel.text = self.activity.contactNumber;
    self.deadLineLabel.text = self.activity.registrationDeadline;
    // 防止主线程卡顿
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSAttributedString *content = [self convertHtmlStr:self.activity.content];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentLabel.attributedText = content;
            CGRect rect = [self.contentLabel.attributedText boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) context:nil];
            self.backViewHeightConstraint.constant = kScreenWidth * 2 / 5 + (20 + 40 + 10) + (10 + 260) + rect.size.height;
        });
    });
//    NSAttributedString *content = [self convertHtmlStr:self.activity.content];
//    self.contentLabel.attributedText = content;
//    CGRect rect = [self.contentLabel.attributedText boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) context:nil];
//    self.backViewHeightConstraint.constant = kScreenWidth * 2 / 5 + (20 + 40 + 10) + (10 + 260) + rect.size.height;
}

- (NSAttributedString *)convertHtmlStr:(NSString *)htmlStr {
    NSAttributedString *str = nil;
    NSData *data = [htmlStr dataUsingEncoding:NSUnicodeStringEncoding];
    str = [[NSAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return str;
}

- (IBAction)footerBtnAction:(id)sender {
    XDParticipatorListController *listVC = [[XDParticipatorListController alloc] init];
    listVC.activity = self.activity;
    [self.navigationController pushViewController:listVC animated:YES];
}

@end
