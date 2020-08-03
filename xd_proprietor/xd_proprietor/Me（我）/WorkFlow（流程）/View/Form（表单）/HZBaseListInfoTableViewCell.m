//
//  HZBaseListInfoTableViewCell.m
//  Pods
//
//  Created by mason on 2017/7/31.
//
//

#import "HZBaseListInfoTableViewCell.h"
#import "BRPlaceholderTextView.h"


@interface HZBaseListInfoTableViewCell()
<
UITextViewDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIView *operationContainView;
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *inputTextView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *lookMapPahtButton;

@end

@implementation HZBaseListInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.inputTextView.layer.cornerRadius = 5.f;
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.layer.borderWidth = 1.f;
    self.inputTextView.layer.borderColor = UIColorHex(dedcd7).CGColor;
    self.inputTextView.backgroundColor = UIColorHex(fafafa);
    self.inputTextView.delegate = self;
    
    self.lookMapPahtButton.layer.cornerRadius = 3;
    self.lookMapPahtButton.layer.masksToBounds = YES;
    self.lookMapPahtButton.layer.borderWidth = 1.f;
    self.lookMapPahtButton.layer.borderColor = UIColorHex(0879D6).CGColor;
    
    [self.textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChange:(UITextField *)textField {
    if (self.inputContentChangeBlock) {
        self.inputContentChangeBlock(textField.text);
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.inputContentChangeBlock) {
        self.inputContentChangeBlock(textView.text);
    }
}

- (void)setBaseModel:(HZBaseModel *)baseModel {
    _baseModel = baseModel;
    self.titleLabel.text = baseModel.title;
    self.valueLabel.text = [XDUtil stringIsEmpty:baseModel.value]? @" " : baseModel.value;
    self.valueLabel.textColor = baseModel.valueTextColor;
    self.textField.text = baseModel.value;
    
    self.valueLabel.hidden = YES;
    self.operationContainView.hidden = YES;
    self.inputTextView.hidden = YES;
    self.arrowImageView.hidden = YES;
    self.textField.hidden = YES;
    self.lookMapPahtButton.hidden = YES;
    
    if (baseModel.baseType == HZBaseTypeOperation) {
        self.operationContainView.hidden = NO;
        self.valueLabel.hidden = NO;
    } else if (baseModel.baseType == HZBaseTypeText) {
        self.textField.placeholder = @"请填写";
        self.valueLabel.hidden = NO;
    } else if (baseModel.baseType == HZBaseTypeImage) {
        self.valueLabel.hidden = NO;
    } else if (baseModel.baseType == HZBaseTypeTextWithArrow) {
        self.valueLabel.hidden = NO;
        self.arrowImageView.hidden = NO;
    } else if (baseModel.baseType == HZBaseTypeTextView) {
        self.inputTextView.hidden = NO;
        self.inputTextView.placeholder = [[NSString stringWithFormat:@"请输入%@", baseModel.title] stringByReplacingOccurrencesOfString:@"：" withString:@""];
        [self.inputTextView setPlaceholderColor:RGB(120, 120, 120)];
        self.inputTextView.text = baseModel.value;
    } else if (baseModel.baseType == HZBaseTypeTextField) {
        self.textField.placeholder = @"请填写";
        self.textField.hidden = NO;
    } else if (baseModel.baseType == HZBaseTypeTextWithButton) {
        self.valueLabel.hidden = NO;
        self.lookMapPahtButton.hidden = NO;
    }
}

- (IBAction)phoneAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(makePhone)]) {
        [self.delegate makePhone];
    }
}

- (IBAction)sendMessageAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(sendMesInfo)]) {
        [self.delegate sendMesInfo];
    }
}

- (IBAction)lookMapPathAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lookMapPath)]) {
        [self.delegate lookMapPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
