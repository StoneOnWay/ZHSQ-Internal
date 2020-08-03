//
//  XDParkPayController.m
//  xd_proprietor
//
//  Created by stone on 17/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDParkPayController.h"
#import "XDBillModel.h"
#import "XDDoPaymentController.h"
#import "RZCarPlateNoTextField.h"
#import "RZCarPlateNoKeyBoardViewModel.h"
#import "UIImage+Extension.h"

#define kCarPlateNoLength 8
#define kTextFieldHeight 44

@interface XDParkPayController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *inTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic, weak) UIImageView *energyView;
@property (nonatomic, strong) UIBarButtonItem *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plateContentViewHeightConstant;

@property (weak, nonatomic) IBOutlet UIView *plateNoTextContentView;
@property (nonatomic, strong) NSMutableArray <NSString *> *plateInputs;
@property (nonatomic, strong) NSMutableArray <RZCarPlateNoTextField *> *textFields;
@property (nonatomic, copy) NSString *curPlateNo;

@property (nonatomic, strong) XDBillModel *myBill;

@end

@implementation XDParkPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"停车缴费";
    // 湘 A7k566
    
    [self configPlateNoTextField];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:(UIBarButtonItemStylePlain) target:self action:@selector(queryCarPayment)];
    self.navigationItem.rightBarButtonItem = rightBtn;
//    self.rightBtn = rightBtn;
}

- (void)queryCarPayment {
    [self.view endEditing:YES];
    self.curPlateNo = @"";
    for (RZCarPlateNoTextField *textField in self.textFields) {
        self.curPlateNo = [self.curPlateNo stringByAppendingString:textField.text];
    }
    [self queryPayment];
}

#pragma mark - plate no text field
- (void)configPlateNoTextField {
    _textFields = [NSMutableArray new];
    _plateInputs = [NSMutableArray new];
    CGFloat textFieldHeight = kTextFieldHeight;
    CGFloat textFieldWidth = ((kScreenWidth - 20) - (5 * (kCarPlateNoLength + 1))) / kCarPlateNoLength;
    if ([XDUtil isIPad]) {
        self.plateContentViewHeightConstant.constant = textFieldWidth;
        textFieldHeight = textFieldWidth - 2 * 8;
    }
    for (NSInteger i = 0; i < kCarPlateNoLength; i ++) {
        [_plateInputs addObject:@""];
        
        RZCarPlateNoTextField *textField = [[RZCarPlateNoTextField alloc] initWithFrame:CGRectMake(5 + (i * (textFieldWidth + 5)), 8, textFieldWidth, textFieldHeight)];
        textField.rz_showCarPlateNoKeyBoard = YES;
        textField.rz_checkCarPlateNoValue = NO;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.rz_maxLength = i == kCarPlateNoLength - 1? 1 : 2; // 最后一个输入一位，其他输入2位，第二位的时候跳格到下一个
        // 新能源
        if (i == kCarPlateNoLength - 1) {
            textField.delegate = self;
            UIImageView *newEnergy;
            if ([XDUtil isIPad]) {
                CGFloat y = (textFieldHeight - (textFieldWidth - 40)) / 2;
                newEnergy = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, textFieldWidth - 40, textFieldWidth - 40)];
            } else {
                CGFloat y = (textFieldHeight - (textFieldWidth - 10)) / 2;
                newEnergy = [[UIImageView alloc] initWithFrame:CGRectMake(5, y, textFieldWidth - 10, textFieldWidth - 10)];
            }
            self.energyView = newEnergy;
            newEnergy.image = [UIImage imageNamed:@"bg_xly"];
            [textField addSubview:newEnergy];
            textField.background = [UIImage imageWithSize:textField.bounds.size borderColor:[UIColor colorWithWhite:0.9 alpha:1] borderWidth:2];
        } else {
            [self setTextFieldBorder:textField];
        }
        [self.plateNoTextContentView addSubview:textField];
        textField.tag = i;
        
        if (i != 0) {
            [textField rz_changeKeyBoard:NO];
        }
        
        [_textFields addObject:textField];
        textField.rz_textFieldEditingValueChanged = ^(RZCarPlateNoTextField * _Nonnull textField) {
            [self textFieldValueChanged:textField];
        };
    }
}

- (void)setTextFieldBorder:(UITextField *)textField {
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 3;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.energyView.hidden = YES;
    [self setTextFieldBorder:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        self.energyView.hidden = NO;
    } else {
        self.energyView.hidden = YES;
    }
    textField.background = [UIImage imageWithSize:textField.bounds.size borderColor:[UIColor colorWithWhite:0.9 alpha:1] borderWidth:2];
    textField.layer.borderWidth = 0;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([self checkPlateNoIntelligent]) {
//        self.navigationItem.rightBarButtonItem = self.rightBtn;
//    } else {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
//    return YES;
//}

//- (BOOL)checkPlateNoIntelligent {
//    int i = 0;
//    for (int j = 0; j < self.plateInputs.count - 1; j++) {
//        if (![self.plateInputs[j] isEqualToString:@""]) {
//            i += 1;
//        }
//    }
//
//    if (i >= kCarPlateNoLength) {
//        return YES;
//    } else {
//        return NO;
//    }
//}

- (void)textFieldValueChanged:(RZCarPlateNoTextField *)textFiled {
//    if ([self checkPlateNoIntelligent:isDel]) {
//        self.navigationItem.rightBarButtonItem = self.rightBtn;
//    } else {
//        self.navigationItem.rightBarButtonItem = nil;
//    }

    NSString *originText = self.plateInputs[textFiled.tag];
    NSString *newText = textFiled.text;
    
    RZCarPlateNoTextField *leftTextField = [self safeArrayAtIndex:textFiled.tag - 1];
    RZCarPlateNoTextField *rightTextField = [self safeArrayAtIndex:textFiled.tag + 1];
    
    RZCarPlateNoTextField *flagTextField;
    
    // 0 ..1
    if (originText.length == 0 && newText.length == 1) {
        [self.plateInputs replaceObjectAtIndex:textFiled.tag withObject:newText];
        flagTextField = rightTextField;
    } else if (originText.length == 1 && newText.length == 2) { // 1..2
        NSString *left = [newText substringToIndex:1];
        NSString *right = [newText substringFromIndex:1];
        textFiled.text = left;
        rightTextField.text = right;
        [self.plateInputs replaceObjectAtIndex:textFiled.tag withObject:left];
        if (rightTextField) {
            [self.plateInputs replaceObjectAtIndex:rightTextField.tag withObject:right];
            flagTextField = rightTextField;
        }
    } else if (originText.length == 1 && newText.length == 0){ // 1.。0
        [self.plateInputs replaceObjectAtIndex:textFiled.tag withObject:@""];
    } else if (originText.length == 0 && newText.length == 0){ // 0.。0
        [self.plateInputs replaceObjectAtIndex:textFiled.tag withObject:@""];
        flagTextField = leftTextField;
    }
    if([self regexPlateNo]) {
        flagTextField = textFiled;
    }
    if (flagTextField) {
        [flagTextField becomeFirstResponder];
    }
}

- (RZCarPlateNoTextField *)safeArrayAtIndex:(NSInteger)index {
    if (index <= self.textFields.count - 1) {
        return self.textFields[index];
    }
    return nil;
}

- (BOOL)regexPlateNo {
    NSString *province = self.plateInputs[0];
    NSString *provinceCode = self.plateInputs[1];
    
    NSString *last;
    NSInteger index = 2;
    for (NSInteger i = self.plateInputs.count - 1; i > 1; i--) {
        last = self.plateInputs[i];
        if (last.length > 0) {
            index = i;
            break;
        }
    }
    BOOL flag = NO;
    if (![RZCarPlateNoKeyBoardViewModel rz_regexText:province regex:rz_province_Regex]) {
        [self.plateInputs replaceObjectAtIndex:0 withObject:@""];
        flag = YES;
    }
    if (![RZCarPlateNoKeyBoardViewModel rz_regexText:provinceCode regex:rz_province_code_Regex]) {
        [self.plateInputs replaceObjectAtIndex:1 withObject:@""];
        flag = YES;
    }
    for (NSInteger i = 2; i < index; i++) {
        NSString *charText = self.plateInputs[i];
        if (![RZCarPlateNoKeyBoardViewModel rz_regexText:charText regex:rz_plateNo_code_Regex]) {
            [self.plateInputs replaceObjectAtIndex:i withObject:@""];
            flag = YES;
        }
    }
    if (![RZCarPlateNoKeyBoardViewModel rz_regexText:last regex:rz_plateNo_code_end_Regx]) {
        [self.plateInputs replaceObjectAtIndex:index withObject:@""];
        flag = YES;
    }
    if (flag) {
        __weak typeof(self) weakSelf = self;
        [self.plateInputs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            weakSelf.textFields[idx].text = obj;
        }];
    }
    return flag;
}

- (IBAction)payAction:(id)sender {
    typeof (self)weakSelf = self;
    XDDoPaymentController *payVC = [[XDDoPaymentController alloc] init];
    payVC.bill = self.myBill;
    payVC.hasPaidBlock = ^{
        weakSelf.totalPayLabel.text = @"0元";
        weakSelf.paidLabel.text = [NSString stringWithFormat:@"%@元", weakSelf.myBill.supposeCost];
        weakSelf.payButton.hidden = YES;
    };
    [self.navigationController pushViewController:payVC animated:YES];

}

// 获取停车账单
- (void)queryPayment {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSUInteger length = self.curPlateNo.length;
    if (length != kCarPlateNoLength && length != kCarPlateNoLength - 1) {
        NSLog(@"请输入正确的车牌号码!");
        [XDUtil showToast:@"请输入正确的车牌号码!"];
        return;
    }
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
        @"plateNo":self.curPlateNo
    };
    WEAKSELF
    [XDHTTPRequst getVehicleBillWithDic:dic phaseId:loginInfo.userModel.currentDistrict.phaseId succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            weakSelf.myBill = [XDBillModel mj_objectWithKeyValues:res[@"result"]];
            NSString *suppposeCos = nil;
            if (!weakSelf.myBill.supposeCost) {
                suppposeCos = @"0";
            } else {
                suppposeCos = weakSelf.myBill.supposeCost;
            }
            weakSelf.inTimeLabel.text = weakSelf.myBill.enterTime;
            weakSelf.totalTimeLabel.text = [NSString stringWithFormat:@"%d分钟", weakSelf.myBill.parkTime.intValue];
            weakSelf.totalPayLabel.text = [NSString stringWithFormat:@"%@元", suppposeCos];;
            weakSelf.paidLabel.text = [NSString stringWithFormat:@"%@元", weakSelf.myBill.paidCost];
            weakSelf.payButton.hidden = NO;
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (XDBillModel *)myBill {
    if (!_myBill) {
        _myBill = [[XDBillModel alloc] init];
    }
    return _myBill;
}

@end
