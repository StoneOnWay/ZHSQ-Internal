//
//  XDPersonalInfoController.m
//  个人资料
//
//  Created by stone on 14/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDPersonalInfoController.h"
#import "XDPersonalConfigModel.h"
#import "XDPersonInfoCell.h"
#import "XDNameEditController.h"
#import "WSDatePickerView.h"

@interface XDPersonalInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation XDPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self configDataSource];
}

- (void)configTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"XDPersonInfoCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDPersonInfoCell"];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.tableView.backgroundColor = litterBackColor;
}

- (void)configDataSource {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    [self.itemArray removeAllObjects];
    NSMutableArray *section1Array = [[NSMutableArray alloc] init];
    NSMutableArray *section2Array = [[NSMutableArray alloc] init];
    XDPersonalConfigModel *headModel = [[XDPersonalConfigModel alloc] init];
    headModel.title = @"头像";
    headModel.subTitle = @"";
    headModel.isImage = YES;
    headModel.hasArrow = YES;
    headModel.headUrl = loginInfo.userModel.avatarResource.url;
    [section1Array addObject:headModel];
    
    XDPersonalConfigModel *nickModel = [[XDPersonalConfigModel alloc] init];
    nickModel.title = @"昵称";
    nickModel.subTitle = loginInfo.userModel.nickName;
    nickModel.isImage = NO;
    nickModel.hasArrow = YES;
    [section2Array addObject:nickModel];
    
    XDPersonalConfigModel *phoneModel = [[XDPersonalConfigModel alloc] init];
    phoneModel.title = @"电话";
    phoneModel.subTitle = loginInfo.userModel.mobile;
    phoneModel.isImage = NO;
    phoneModel.hasArrow = NO;
    [section2Array addObject:phoneModel];
    
    XDPersonalConfigModel *genderModel = [[XDPersonalConfigModel alloc] init];
    genderModel.title = @"性别";
    NSString *gender = nil;
    if ([loginInfo.userModel.gender isEqualToString:@"0"]) {
        gender = @"男";
    } else if ([loginInfo.userModel.gender isEqualToString:@"1"]) {
        gender = @"女";
    } else {
        gender = @"未知";
    }
    genderModel.subTitle = gender;
    genderModel.isImage = NO;
    genderModel.hasArrow = YES;
    [section2Array addObject:genderModel];
    
    XDPersonalConfigModel *birthModel = [[XDPersonalConfigModel alloc] init];
    birthModel.title = @"生日";
    birthModel.subTitle = loginInfo.userModel.birthday;
    birthModel.isImage = NO;
    birthModel.hasArrow = YES;
    [section2Array addObject:birthModel];
    
    [self.itemArray addObject:section1Array];
    [self.itemArray addObject:section2Array];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDPersonalConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if (model.isImage) {
        return 100;
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDPersonInfoCell" forIndexPath:indexPath];
    XDPersonalConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    cell.personInfo = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    XDPersonInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    XDPersonalConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"头像"]) {
        if (model.hasArrow) {
            [self takePhoto:cell];
        }
    } else if ([model.title isEqualToString:@"昵称"]) {
        if (model.hasArrow) {
            XDNameEditController *nameVC = [[XDNameEditController alloc] init];
            nameVC.nickName = loginInfo.userModel.nickName;
            [self.navigationController pushViewController:nameVC animated:YES];
        }
    } else if ([model.title isEqualToString:@"生日"]) {
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
            NSString *timeStr = [startDate stringWithFormat:@"yyyy-MM-dd"];
            [self commitBirthday:timeStr];
        }];
        datepicker.doneButtonColor = buttonColor; // 确定按钮的颜色
        [datepicker show];
    } else if ([model.title isEqualToString:@"性别"]) {
        if (model.hasArrow) {
            [self alterSexPortrait];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
        if (!header) {
            header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        }
        header.frame = CGRectMake(0, 0, kScreenWidth, 20);
        UIView *view = [[UIView alloc] initWithFrame:header.bounds];
        view.backgroundColor = litterBackColor;
        [header addSubview:view];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20;
    }
    return 0.01;
}

#pragma mark - UIAlert
- (void)takePhoto:(XDPersonInfoCell *)cell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet ];
    //拍照
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    //相机胶卷
    UIAlertAction *Action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    //取消style:UIAlertActionStyleDefault
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:Action];
    [alert addAction:Action1];
    [alert addAction:cancelAction];
    if ([XDUtil isIPad]) {
        UIPopoverPresentationController *popoverVC = [alert popoverPresentationController];
        popoverVC.sourceView = cell;
        popoverVC.sourceRect = cell.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)photoWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    NSDictionary *textAt = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    [imagePicker.navigationBar setTitleTextAttributes:textAt];
    imagePicker.navigationBar.tintColor = [UIColor blackColor];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = YES;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self commitAvatar:info[@"UIImagePickerControllerEditedImage"]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark----- 选择性别弹出框
-(void)alterSexPortrait {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self commitGender:0];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self commitGender:1];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - commit edit data
- (void)commitAvatar:(UIImage *)image {
    @weakify(self)
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    [MBProgressHUD showActivityMessageInView:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"avatar.jpg"];
    NSLog(@"avatar image file path -- %@", filePath);
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [imageData writeToFile:filePath atomically:YES];
    [XDHTTPRequst uploadFileWithPath:filePath dic:nil name:@"UploadFile" succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            NSString *avatarId = res[@"result"][@"id"];
            NSString *domain = res[@"result"][@"domain"];
            NSString *url = res[@"result"][@"url"];
            NSDictionary *dic = @{
                                  @"avatarId":avatarId,
                                  @"id":loginInfo.userModel.userID
                                  };
            [XDHTTPRequst updateUserSpecificFieldWithDic:dic succeed:^(id res) {
                @strongify(self)
                [MBProgressHUD hideHUD];
                if ([res[@"code"] integerValue] == 200) {
                    XDResourceModel *model = [[XDResourceModel alloc] init];
                    model.url = [domain stringByAppendingString:url];
                    loginInfo.userModel.avatarResource = model;
                    [XDArchiverManager saveLoginInfo:loginInfo];
                    [self configDataSource];
                } else {
                    [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
                }
            } fail:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [XDHTTPRequst showErrorMessageWith:error];
            }];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)commitBirthday:(NSString *)birthday {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    @weakify(self)
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
                          @"birthday":birthday,
                          @"id":loginInfo.userModel.userID
                          };
    [XDHTTPRequst updateUserSpecificFieldWithDic:dic succeed:^(id res) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            loginInfo.userModel.birthday = birthday;
            [XDArchiverManager saveLoginInfo:loginInfo];
            [self configDataSource];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)commitGender:(NSInteger)gender {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    @weakify(self)
    [MBProgressHUD showActivityMessageInView:nil];
    NSDictionary *dic = @{
                          @"gender":@(gender),
                          @"id":loginInfo.userModel.userID
                          };
    [XDHTTPRequst updateUserSpecificFieldWithDic:dic succeed:^(id res) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            loginInfo.userModel.gender = [NSString stringWithFormat:@"%ld", gender];
            [XDArchiverManager saveLoginInfo:loginInfo];
            [self configDataSource];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark - lazy load
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end
