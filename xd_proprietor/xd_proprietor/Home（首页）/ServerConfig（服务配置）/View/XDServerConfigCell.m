//
//  Created by cfsc on 2020/7/13.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDServerConfigCell.h"
#import "XDServerDataManager.h"

@interface XDServerConfigCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (nonatomic, strong) NSIndexPath *indexPath;


@end

@implementation XDServerConfigCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = RGB(246, 246, 246);
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 0;
}

- (void)resetModel:(XDServerConfigCellModel *)data :(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonState:) name:notification_CellBeganEditing object:nil];
    self.data = data;
    self.label.text = data.name;
    self.indexPath = indexPath;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data.iconUrl]];
    self.contentView.backgroundColor = data.backGroundColor;
    if ([XDServerDataManager shareDataManager].isEditing) {
        self.layer.borderWidth = 0.5f;
        self.stateButton.hidden = NO;
        [self showStateButton];
    }else{
        self.layer.borderWidth = 0;
        self.stateButton.hidden = YES;
    }
}

- (void)showStateButton {
    switch (self.data.state) {
        case ServeAdd:
            self.stateButton.enabled = YES;
            [self.stateButton setImage:[UIImage imageNamed:@"btn_bridge_add"] forState:UIControlStateNormal];
            break;
        case ServeSelected:
            if (self.indexPath.section == 0) {
                self.stateButton.enabled = YES;
                [self.stateButton setImage:[UIImage imageNamed:@"btn_bridge_delete"] forState:UIControlStateNormal];

            } else {
                if ([[XDServerDataManager shareDataManager] isMyProgram:self.data]) {
                    self.stateButton.enabled = NO;
                    [self.stateButton setImage:[UIImage imageNamed:@"btn_bridge_ok"] forState:UIControlStateNormal];

                } else {
                    self.stateButton.enabled = YES;
                    [self.stateButton setImage:[UIImage imageNamed:@"btn_bridge_add"] forState:UIControlStateNormal];
                }
            }
            break;
    }
}

- (void)changeButtonState:(NSNotification *)notification {
    NSString *string = notification.object;
    if ([string isEqualToString:@"yes"]) {
        self.layer.borderWidth = 0.5f;
        self.stateButton.hidden = NO;
        [self showStateButton];
        self.stateButton.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.1 animations:^{
            self.stateButton.transform = CGAffineTransformIdentity;
        }];
    } else {
        self.layer.borderWidth = 0;
        [UIView animateWithDuration:0.1 animations:^{
            self.stateButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
        } completion:^(BOOL finished) {
            self.stateButton.transform = CGAffineTransformIdentity;
            self.stateButton.hidden = YES;
        }];
    }
}


- (IBAction)buttonClick:(UIButton *)sender {
    sender.enabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_CellStateChange object:self];

}

@end
