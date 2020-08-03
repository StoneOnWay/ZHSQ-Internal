//
//  XDAboutController.m
//  xd_proprietor
//
//  Created by cfsc on 2019/7/31.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDAboutController.h"

@interface XDAboutController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation XDAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = currentVersion;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
