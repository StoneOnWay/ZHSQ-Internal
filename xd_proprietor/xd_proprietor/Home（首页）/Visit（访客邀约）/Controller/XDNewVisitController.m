//
//  Created by cfsc on 2020/2/5.
//  Copyright © 2020年 cfsc. All rights reserved.
//

#import "XDNewVisitController.h"
#import "XDVisitDetailController.h"
#import "WSDatePickerView.h"
#import "GSPopoverViewController.h"
#import "XDTypePopCell.h"
#import "XDVisitorModel.h"

@interface XDNewVisitController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *nameTexts;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabel;

@property (strong, nonatomic) NSString *numberTimes;
//弹出框
@property (strong ,nonatomic)GSPopoverViewController *popView;
//pop的contentView
@property (strong , nonatomic)UITableView *tableView;

@end

@implementation XDNewVisitController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"新邀请";
    self.view.backgroundColor = litterBackColor;
    self.numberTimes = @"2";
    self.numberLabel.text = self.numberTimes;
    self.effectTimeLabel.text = [XDUtil getNowTimeStrWithFormatter:VISIT_DATE_FORMATTER];
    self.expireTimeLabel.text = [XDUtil getDateStrWithFormatter:VISIT_DATE_FORMATTER sinceNow:5*60];
}

- (void)createNewVisit {
    if (self.nameTexts.text.length == 0) {
        [XDUtil showToast:@"被邀请人名不能为空！"];
        return;
    }
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *cardNo = loginInfo.userModel.defaultCardNo;
    NSString *phaseId = loginInfo.userModel.currentDistrict.phaseId;
    if (!cardNo || !phaseId) {
        [MBProgressHUD showTipMessageInView:@"登录用户信息有误！"];
        return;
    }
    NSDate *effectDate = [NSDate date:self.effectTimeLabel.text WithFormat:VISIT_DATE_FORMATTER];
    NSDate *expireDate = [NSDate date:self.expireTimeLabel.text WithFormat:VISIT_DATE_FORMATTER];
    NSTimeInterval effectInterval = [effectDate timeIntervalSince1970];
    NSTimeInterval expireInterval = [expireDate timeIntervalSince1970];
    if (expireInterval < effectInterval) {
        [XDUtil showToast:@"失效日期不能小于生效日期！"];
        return;
    }
    if (expireInterval - effectInterval > 48 * 60 * 60) {
        [XDUtil showToast:@"失效日期和生效日期间隔不能超过48小时！"];
        return;
    }
    NSDictionary *dic = @{
                          @"cardNo":cardNo,
                          @"effectTime":[self convertStr:self.effectTimeLabel.text],
                          @"expireTime":[self convertStr:self.expireTimeLabel.text],
                          @"openTimes":self.numberLabel.text.numberValue,
                          @"visitorName":self.nameTexts.text,
                          @"phaseId":phaseId,
                          };
    [MBProgressHUD showActivityMessageInView:nil];
    WEAKSELF
    [XDHTTPRequst addNewVisitWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            NSString *codeUrl = res[@"result"][@"qrCodeUrl"];
            XDVisitorModel *model = [[XDVisitorModel alloc] init];
            model.visitorName = weakSelf.nameTexts.text;
            model.expireTime = weakSelf.expireTimeLabel.text;
            model.effectTime = weakSelf.effectTimeLabel.text;
            model.openTimes = weakSelf.numberLabel.text.intValue;
            model.qrcodeUrl = codeUrl;
            XDVisitDetailController *detail = [[XDVisitDetailController alloc] init];
            detail.visitModel = model;
            detail.isAddNew = YES;
            [weakSelf.navigationController pushViewController:detail animated:YES];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (IBAction)newCodeBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self createNewVisit];
}

- (IBAction)chooseTimeBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];

    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *startDate) {
        NSString *timeStr = [startDate stringWithFormat:VISIT_DATE_FORMATTER];
        if (sender.tag == 100) {
            self.effectTimeLabel.text = timeStr;
        } else {
            self.expireTimeLabel.text = timeStr;
        }
    }];
    datepicker.doneButtonColor = BianKuang; // 确定按钮的颜色
    [datepicker show];
}

- (IBAction)effectiveNumber:(UIButton *)sender forEvent:(UIEvent *)event {
    [self setUpPopView:sender];
    //一定要这个不要坐标不对
    CGRect rect = [self.backView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    self.popView.showAnimation = GSPopoverViewShowAnimationBottomTop;
    [self.popView showPopoverWithRect:rect animation:YES];
}

/**
 *  插入popView
 */
- (void)setUpPopView:(UIButton *)sender {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , 0,  sender.width, 120)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 40;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    self.popView = [[GSPopoverViewController alloc] initWithShowView:self.tableView];
    self.popView.borderWidth = 1;
    self.popView.borderColor = BianKuang;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDTypePopCell *cell = [XDTypePopCell cellWithTableView:tableView];
    cell.textLabels.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.numberTimes = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    self.numberLabel.text = self.numberTimes;
    [self.popView dissPopoverViewWithAnimation:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSString *)convertStr:(NSString *)str {
    return [[[[str stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""] substringFromIndex:2];
}

@end
