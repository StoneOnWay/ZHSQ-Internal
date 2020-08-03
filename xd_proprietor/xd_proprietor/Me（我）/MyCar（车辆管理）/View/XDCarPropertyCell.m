//
//  XDCarPropertyCell.m
//  xd_proprietor
//
//  Created by stone on 21/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDCarPropertyCell.h"
#import "XDAddCarConfigModel.h"
#import "RZCarPlateNoTextField.h"
#import "RZCarPlateNoKeyBoardViewModel.h"

#define kCarPlateNoLength 8
#define kTextFieldHeight 40

@interface XDCarPropertyCell () <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray <NSString *> *plateInputs;
@property (nonatomic, strong) NSMutableArray <RZCarPlateNoTextField *> *textFields;
@property (nonatomic, copy) NSString *curPlateNo;
@property (nonatomic, weak) UIImageView *energyView;
@end

@implementation XDCarPropertyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(XDAddCarConfigModel *)model {
    _model = model;
    self.titleLable.text = model.title;
    if (model.type == CarPropertyTypePlateNo) {
        self.necessaryTagLabel.hidden = NO;
        self.valueLabel.hidden = YES;
        self.arrowImageView.hidden = YES;
        [self configPlateNoTextField:self.backView model:model];
    } else {
        self.necessaryTagLabel.hidden = YES;
        self.valueLabel.hidden = NO;
        self.arrowImageView.hidden = NO;
        self.valueLabel.text = model.value;
    }
}

#pragma mark - plate no text field
- (void)configPlateNoTextField:(UIView *)view model:(XDAddCarConfigModel *)model {
    if (model.textFields) {
        // 防止之前的车牌数组被覆盖
        return;
    }
    
    _textFields = [NSMutableArray new];
    _plateInputs = [NSMutableArray new];
    model.textFields = _textFields;
    NSArray *plateCharArray = [self plateNoCharArrayWith:model.value];
    CGFloat textFieldWidth = ((kScreenWidth - 120) - (5 * (kCarPlateNoLength + 1))) / kCarPlateNoLength;
    for (NSInteger i = 0; i < kCarPlateNoLength; i ++) {
    
        RZCarPlateNoTextField *textField = [[RZCarPlateNoTextField alloc] initWithFrame:CGRectMake(5 + (i * (textFieldWidth + 5)), 8, textFieldWidth, kTextFieldHeight)];
        textField.rz_showCarPlateNoKeyBoard = YES;
        textField.rz_checkCarPlateNoValue = NO;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.rz_maxLength = i == kCarPlateNoLength - 1? 1 : 2; // 最后一个输入一位，其他输入2位，第二位的时候跳格到下一个
        if (plateCharArray.count != kCarPlateNoLength) {
            // 不是编辑
            [_plateInputs addObject:@""];
        } else {
            // 编辑
            textField.text = plateCharArray[i];
            [_plateInputs addObject:plateCharArray[i]];
            textField.userInteractionEnabled = NO; // 编辑不允许修改车牌
        }
        // 新能源
        if (i == kCarPlateNoLength - 1) {
            textField.delegate = self;
            CGFloat y = (kTextFieldHeight - (textFieldWidth - 10)) / 2;
            UIImageView *newEnergy = [[UIImageView alloc] initWithFrame:CGRectMake(5, y, textFieldWidth - 10, textFieldWidth - 10)];
            if ([XDUtil isIPad]) {
                y = (kTextFieldHeight - (textFieldWidth - 40)) / 2;
                newEnergy = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, textFieldWidth - 40, textFieldWidth - 40)];
            }
            self.energyView = newEnergy;
            newEnergy.image = [UIImage imageNamed:@"bg_xly"];
            [textField addSubview:newEnergy];
            textField.background = [UIImage imageWithSize:textField.bounds.size borderColor:[UIColor colorWithWhite:0.9 alpha:1] borderWidth:2];
            if (plateCharArray.count == kCarPlateNoLength) {
                self.energyView.hidden = YES;
                [self setTextFieldBorder:textField];
            }
        } else {
            [self setTextFieldBorder:textField];
        }
        [view addSubview:textField];
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

- (NSMutableArray *)plateNoCharArrayWith:(NSString *)plateNo {
    NSMutableArray *array = [NSMutableArray array];
    if (plateNo) {
        array = [XDUtil convertToArrayByStr:plateNo];
        if (array.count != kCarPlateNoLength) {
            // 不是新能源车，添加一位@""
            [array addObject:@""];
        }
    }
    return array;
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

- (void)textFieldValueChanged:(RZCarPlateNoTextField *)textFiled {
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

@end
