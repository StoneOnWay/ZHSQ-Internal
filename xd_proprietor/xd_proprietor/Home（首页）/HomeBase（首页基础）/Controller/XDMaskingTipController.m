//
//  Created by cfsc on 2020/3/9.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDMaskingTipController.h"
#import "XDUnitSelectController.h"

@interface XDMaskingTipController ()

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectRoomButton;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@end

@implementation XDMaskingTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRoundCorner];
    XDLoginInfoModel *model = [XDArchiverManager loginInfo];
    self.projectNameLabel.text = model.userModel.currentDistrict.projectName;
}

- (void)setRoundCorner {
    self.selectRoomButton.layer.cornerRadius = 20;
    self.selectRoomButton.layer.masksToBounds = YES;
    self.focusButton.layer.cornerRadius = 20;
    self.focusButton.layer.masksToBounds = YES;
    self.whiteView.layer.cornerRadius = 5;
    self.whiteView.layer.masksToBounds = YES;
}

- (IBAction)selectRoomAction:(id)sender {
    BaseTabBarViewController *tabBarVC = (BaseTabBarViewController *)self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        tabBarVC.selectedIndex = tabBarVC.viewControllers.count - 1;
        XDUnitSelectController *roomSelVC = [[XDUnitSelectController alloc] init];
        BaseNavigationController *nav = [tabBarVC.viewControllers lastObject];
        [nav pushViewController:roomSelVC animated:YES];
    }];
}

- (IBAction)focusAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)cancelMaskingAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
