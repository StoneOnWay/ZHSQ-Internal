//
//  Created by cfsc on 2020/3/6.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDProjectSelectController.h"
#import "XDHouseTreeModel.h"

@interface XDProjectSelectController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation XDProjectSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(serachAction)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self loadData];
}

- (void)loadData {
    WEAKSELF
    [MBProgressHUD showActivityMessageInWindow:nil];
    [XDHTTPRequst getHouseCongfigTreeSucceed:^(NSDictionary *res) {
        if ([res[@"code"] integerValue] == 200) {
            XDHouseTreeModel *model = [XDHouseTreeModel mj_objectWithKeyValues:res];
            weakSelf.itemArray = [model.result mutableCopy];
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInWindow:@"请求超时，请稍后再试！" timer:2];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDHouseConfigModel *configModel = self.itemArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor = RGB(79, 79, 79);
    cell.textLabel.text = configModel.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDHouseConfigModel *configModel = self.itemArray[indexPath.row];
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    // 更新服务器上用户绑定的projectID
    NSString *projectID = configModel.key;
    if (!projectID || !loginInfo.userModel.userID) {
        [MBProgressHUD showTipMessageInWindow:@"字典value为空，防止崩溃提示！" timer:2];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSDictionary *dic = @{
                          @"projectId":projectID,
                          @"householdId":loginInfo.userModel.userID
                          };
    [XDHTTPRequst selectCurrentBindingWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            // 更新本地用户信息并进入首页
            [XDHTTPRequst getUserInfoCacheSucceed:^(id res) {
                if ([res[@"code"] integerValue] == 200) {
                    XDUserModel *userModel = [XDUserModel mj_objectWithKeyValues:res[@"result"]];
                    loginInfo.userModel = userModel;
                    [XDArchiverManager saveLoginInfo:loginInfo];
                    [MBProgressHUD hideHUD];
                    // 设置推送别名
                    [[XDCommonBusiness shareInstance] setPushTagsAndAlias];
                    // 进入首页
                    UIWindow *window = [[UIApplication sharedApplication].delegate window];
                    [AppDelegate shareAppDelegate].tabBarViewController = [[BaseTabBarViewController alloc]init];
                    window.rootViewController = [AppDelegate shareAppDelegate].tabBarViewController;
                } else {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showTipMessageInWindow:res[@"message"] timer:2];
                }
            } fail:^(NSError *error) {
                NSLog(@"getUserInfoError--%@", error);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:@"请求超时，请稍后再试！" timer:2];
            }];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInWindow:@"请求超时，请稍后再试！" timer:2];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.canGoBack) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftItemWithImageName:@"nav_btn_back" frame:CGRectMake(0, 0, 40, 40) target:self action:@selector(GoBack)];
        return;
    }
    // 禁止返回
    NSMutableArray *childVCArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    if (childVCArray.count > 0) {
        // 防止闪退
        [childVCArray removeObjectsInRange:NSMakeRange(0, childVCArray.count - 1)];
    }
    self.navigationController.viewControllers = childVCArray;
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)GoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)serachAction {
    [MBProgressHUD showTipMessageInWindow:@"搜索功能"];
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _itemArray;
}

@end
