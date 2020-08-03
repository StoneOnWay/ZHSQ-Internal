//
//  Created by cfsc on 2020/2/26.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDPageContainerController.h"
#import "HMSegmentedControl.h"
#import "XDRoomMemberController.h"
#import "XDOtherRoomController.h"
#import "XDRoomManageController.h"
//#import "UIPageViewController+XDGestureDeal.h"

@interface XDPageContainerController ()
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource
>

@property (weak, nonatomic) IBOutlet UIView *segmentContainerView;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *viewControllerArray;
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation XDPageContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的房屋";
    // 配置导航
    [self configNav];
    // 配置segment
    [self configSegmentView];
    // 配置pageController
    [self configPageController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 禁止返回
    NSMutableArray *childVCArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    if (childVCArray.count > 0) {
        // 防止闪退
        [childVCArray removeObjectsInRange:NSMakeRange(1, childVCArray.count - 2)];
    }
    self.navigationController.viewControllers = childVCArray;
}

- (void)configNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理房屋" style:UIBarButtonItemStyleDone target:self action:@selector(manageRoom)];
}

- (void)configSegmentView {
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"当前房屋", @"其他房屋"]];
    segmentedControl.frame = CGRectMake(0, 0, kScreenWidth*2/5, 40.f);
    segmentedControl.backgroundColor = UIColorHex(ffffff);
    segmentedControl.type = HMSegmentedControlTypeText;
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationBottom;
    segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: UIColorHex(353535)};
    segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: UIColorHex(6190E8)};
    segmentedControl.selectionIndicatorColor = UIColorHex(6190E8);
    segmentedControl.selectionIndicatorHeight = 2.f;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    NSInteger index = [self.toVC isEqualToString:@"XDOtherRoomController"] ? 1 : 0;
    segmentedControl.selectedSegmentIndex = index;
    self.segmentedControl = segmentedControl;
    [self.segmentContainerView addSubview:segmentedControl];
}

- (void)configPageController {
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    XDRoomMemberController *currentRoomVC = [[XDRoomMemberController alloc] init];
    XDOtherRoomController *otherRoomVC = [[XDOtherRoomController alloc] init];
    [self.viewControllerArray addObjectsFromArray:@[currentRoomVC, otherRoomVC]];
    NSInteger index = [self.toVC isEqualToString:@"XDOtherRoomController"] ? 1 : 0;
    [self.pageViewController setViewControllers:@[self.viewControllerArray[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)manageRoom {
    XDRoomManageController *roomManageVC = [[XDRoomManageController alloc] init];
    [self.navigationController pushViewController:roomManageVC animated:YES];
}

#pragma mark - dataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfController:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self.viewControllerArray objectAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == self.viewControllerArray.count) {
        return nil;
    }
    return [self.viewControllerArray objectAtIndex:index];
}

#pragma mark - delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
        self.segmentedControl.selectedSegmentIndex = self.currentIndex;
    }
}

- (NSInteger) indexOfController:(UIViewController *)viewController {
    for (NSInteger i = 0; i < self.viewControllerArray.count; i++) {
        if (viewController == [self.viewControllerArray objectAtIndex:i]) {
            return i;
        }
    }
    return NSNotFound;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    UIPageViewControllerNavigationDirection pageViewControllerNavigationDirection = self.currentIndex < segmentedControl.selectedSegmentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    self.currentIndex = segmentedControl.selectedSegmentIndex;
    [self.pageViewController setViewControllers:@[[self.viewControllerArray objectAtIndex:segmentedControl.selectedSegmentIndex]] direction:pageViewControllerNavigationDirection animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UIPageViewController class]]) {
        self.pageViewController = segue.destinationViewController;
    }
}

- (NSMutableArray *)viewControllerArray {
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
    }
    return _viewControllerArray;
}

@end
