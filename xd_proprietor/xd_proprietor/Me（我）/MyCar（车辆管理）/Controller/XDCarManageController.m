//
//  XDCarManageController.m
//  xd_proprietor
//
//  Created by stone on 21/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDCarManageController.h"
#import "XDAddCarConfigModel.h"
#import "XDCarPropertyCell.h"
#import "XDCarPhotoCell.h"
#import "GSPopoverViewController.h"
#import "HZSingleChoiceListView.h"
#import "HZPopView.h"
#import "XDCarCharterCell.h"
#import "XDCarCharterSelView.h"
#import "XDDoPaymentController.h"
#import "XDCarCharterModel.h"

@interface XDCarManageController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *plateColorArr;
@property (nonatomic, strong) NSMutableArray *plateTypeArr;
@property (nonatomic, strong) NSMutableArray *carColorArr;
@property (nonatomic, strong) NSMutableArray *carTypeArr;
// 请求参数
@property (strong, nonatomic) NSMutableDictionary *parameter;
@property (strong, nonatomic) XDCarCharterSelView *selView;
@end

@implementation XDCarManageController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.vehicleModel) {
        self.title = self.vehicleModel.plateNO;
    } else {
        self.title = @"添加车辆";
    }
    [self configTableView];
    [self loadPopArray];
    [self showConfirmBtn];
}

- (void)showConfirmBtn {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:(UIBarButtonItemStylePlain) target:self action:@selector(confirmAction:)];
}

- (void)loadPopArray {
    [MBProgressHUD showActivityMessageInView:nil];
    dispatch_group_t group = dispatch_group_create();
    [self getPopDatasWithGroup:group code:@"smart-basic.cfc_vehicle_info.plate_type" dataArray:self.plateTypeArr propertyName:@"plateTypeText"];
    [self getPopDatasWithGroup:group code:@"smart-basic.cfc_vehicle_info.plate_color" dataArray:self.plateColorArr propertyName:@"plateColorText"];
    [self getPopDatasWithGroup:group code:@"smart-basic.cfc_vehicle_info.vehicle_type" dataArray:self.carTypeArr propertyName:@"vehicleTypeText"];
    [self getPopDatasWithGroup:group code:@"smart-basic.cfc_vehicle_info.vehicle_color" dataArray:self.carColorArr propertyName:@"vehicleColorText"];
    WEAKSELF
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [weakSelf configDataSource];
    });
}

- (void)getPopDatasWithGroup:(dispatch_group_t)group code:(NSString *)code dataArray:(NSMutableArray *)dataArray propertyName:(NSString *)propertyName {
    dispatch_group_enter(group);
    WEAKSELF
    [XDHTTPRequst getDictItemsWithCode:code succeed:^(id res) {
        dispatch_group_leave(group);
        if ([res[@"code"] integerValue] == 200) {
            NSArray *array = res[@"result"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                HZSingleChoiceModel *model = [[HZSingleChoiceModel alloc] init];
                model.title = dic[@"text"];
                model.typeCode = dic[@"value"];
                if (weakSelf.vehicleModel) {
                    NSDictionary *proDic = [weakSelf.vehicleModel mj_keyValuesWithKeys:@[propertyName]];
                    model.selectedStatus = [model.title isEqualToString:proDic[propertyName]];
                }
                [dataArray addObject:model];
            }
        }
    } fail:^(NSError *error) {
        dispatch_group_leave(group);
    }];
}

- (void)configDataSource {
    XDAddCarConfigModel *plateNoModel = [[XDAddCarConfigModel alloc] init];
    plateNoModel.type = CarPropertyTypePlateNo;
    plateNoModel.title = @"车牌号码";
    plateNoModel.value = self.vehicleModel.plateNO;
    XDAddCarConfigModel *plateColorModel = [[XDAddCarConfigModel alloc] init];
    plateColorModel.type = CarPropertyTypeOther;
    plateColorModel.title = @"车牌颜色";
    plateColorModel.value = self.vehicleModel.plateColorText;
    XDAddCarConfigModel *plateTypeModel = [[XDAddCarConfigModel alloc] init];
    plateTypeModel.type = CarPropertyTypeOther;
    plateTypeModel.title = @"车牌类型";
    plateTypeModel.value = self.vehicleModel.plateTypeText;
    XDAddCarConfigModel *carColorModel = [[XDAddCarConfigModel alloc] init];
    carColorModel.type = CarPropertyTypeOther;
    carColorModel.title = @"车辆颜色";
    carColorModel.value = self.vehicleModel.vehicleColorText;
    XDAddCarConfigModel *carTypeModel = [[XDAddCarConfigModel alloc] init];
    carTypeModel.type = CarPropertyTypeOther;
    carTypeModel.title = @"车辆类型";
    carTypeModel.value = self.vehicleModel.vehicleTypeText;
    XDAddCarConfigModel *carPhotoModel = [[XDAddCarConfigModel alloc] init];
    carPhotoModel.type = CarPropertyTypePhoto;
    carPhotoModel.value = self.vehicleModel.vehicleImageResource.url;
    XDAddCarConfigModel *carCharterModel = [[XDAddCarConfigModel alloc] init];
    carCharterModel.type = CarPropertyTypeCharter;
    carCharterModel.value = self.vehicleModel.type;
    if (!self.vehicleModel) {
        [self.itemArray addObject:@[plateNoModel, plateColorModel, plateTypeModel, carColorModel, carTypeModel, carPhotoModel]];
    } else {
        [self.itemArray addObject:@[carPhotoModel, plateColorModel, plateTypeModel, carColorModel, carTypeModel]];
        if (self.vehicleModel.auditStatus.integerValue == 1) {
            [self.itemArray addObject:@[carCharterModel]];
        }
    }
    [self.tableView reloadData];
}

- (void)configTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"XDCarPropertyCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDCarPropertyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XDCarPhotoCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDCarPhotoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XDCarCharterCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDCarCharterCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.tableView.tableFooterView = [UIView new];
}

// 上传照片到资源服务器
- (void)uploadVehicleResouce:(UIImage *)image {
    [MBProgressHUD showActivityMessageInView:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"vehicleImage.jpg"];
    NSLog(@"vehicle image file path -- %@", filePath);
    [UIImageJPEGRepresentation(image, 0.5) writeToFile:filePath atomically:YES];
    @weakify(self)
    [XDHTTPRequst uploadFileWithPath:filePath dic:@{} name:@"UploadFile" succeed:^(id res) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [self.parameter setValue:res[@"result"][@"resourceKey"] forKey:@"vehicleImageId"];
            for (XDAddCarConfigModel *model in self.itemArray.firstObject) {
                if (model.type == CarPropertyTypePhoto) {
                    model.image = image;
                }
            }
            [self.tableView reloadData];
//            [self showConfirmBtn];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)addVehicle {
    [MBProgressHUD showActivityMessageInView:nil];
    for (XDAddCarConfigModel *model in self.itemArray.firstObject) {
        if (model.type == CarPropertyTypePlateNo) {
            NSString *plateNo = @"";
            for (RZCarPlateNoTextField *textField in model.textFields) {
                plateNo = [plateNo stringByAppendingString:textField.text];
            }
            if ([plateNo isEqualToString:@""]) {
                [MBProgressHUD hideHUD];
                [XDUtil showToast:@"请输入正确的车牌号码！"];
                return;
            }
            [self.parameter setValue:plateNo forKey:@"plateNO"];
        }
    }
    WEAKSELF
    [XDHTTPRequst getUserGenerateIdSucceed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            [self.parameter setValue:res[@"result"] forKey:@"id"];
            [XDHTTPRequst addVehicleWithDic:self.parameter succeed:^(id res) {
                [MBProgressHUD hideHUD];
                if ([res[@"code"] integerValue] == 200) {
                    if (weakSelf.addCarSuccess) {
                        weakSelf.addCarSuccess();
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
                }
            } fail:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [XDHTTPRequst showErrorMessageWith:error];
            }];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)editVehicle {
    [self.parameter setValue:self.vehicleModel.vehicleId forKey:@"id"];
    WEAKSELF
    [XDHTTPRequst editVehicleWithDic:self.parameter succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            if (weakSelf.addCarSuccess) {
                weakSelf.addCarSuccess();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (IBAction)confirmAction:(id)sender {
    [self.view endEditing:YES];
    if (self.vehicleModel) {
        [self editVehicle];
    } else {
        [self addVehicle];
    }
}

- (void)choiceItemWithBaseModel:(XDAddCarConfigModel *)model itemArray:(NSArray *)itemArray{
    __block HZPopView *popView = [HZPopView new];
    CGFloat width = 300.f * kScreenWidth / 375.f;
    HZSingleChoiceListView *singleChoiceView = [HZSingleChoiceListView new];
    singleChoiceView.itemArray = [itemArray copy];
    @weakify(self)
    [singleChoiceView setChoiceResultBlock:^(id result) {
        @strongify(self)
//        [self showConfirmBtn];
        HZSingleChoiceModel *singleChioceModel = result;
        model.value = singleChioceModel.title;
        [self.tableView reloadData];
        [self.parameter setValue:singleChioceModel.typeCode forKey:[self keyChange:model.title]];
        [popView diss];
        popView = nil;
    }];
    
    [singleChoiceView setChoiceDismissBlock:^{
        [popView diss];
        popView = nil;
    }];
    [popView popViewWithContenView:singleChoiceView inRect:CGRectMake(0, 0, width, width * 5.f / 6) inContainer:nil];
}

- (NSString *)keyChange:(NSString *)key {
    NSDictionary *dic = @{
        @"车辆颜色" : @"vehicleColor",
        @"车辆类型" : @"vehicleType",
        @"车牌类型" : @"plateType",
        @"车牌颜色" : @"plateColor"
    };
    return dic[key];
}

#pragma mark - UIAlert
- (void)takePhoto:(NSIndexPath *)indexPath {
    XDCarPhotoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet ];
    if ([XDUtil isIPad]) {
        UIPopoverPresentationController *popoverVC = [alert popoverPresentationController];
        popoverVC.sourceView = cell;
        popoverVC.sourceRect = cell.bounds;
    }
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
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    [self uploadVehicleResouce:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDAddCarConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if (model.type == CarPropertyTypePhoto) {
        XDCarPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDCarPhotoCell"];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.addCarPhoto = ^{
            [self takePhoto:indexPath];
        };
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [self takePhoto:indexPath];
        }];
        [cell.photoImageView addGestureRecognizer:tap];
        cell.photoImageView.userInteractionEnabled = YES;
        return cell;
    } else if (model.type == CarPropertyTypeCharter) {
           XDCarCharterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDCarCharterCell"];
           cell.vehicleModel = self.vehicleModel;
           __weak typeof(self)weakSelf = self;
           cell.charterBtnClick = ^{
               if ([tableView.tableFooterView isKindOfClass:XDCarCharterSelView.class]) {
                   tableView.tableFooterView = [UIView new];
               } else {
                   if (!weakSelf.selView) {
                       weakSelf.selView = [XDCarCharterSelView createCarCharterSelView];
                       weakSelf.selView.charterViewClick = ^(CarCharterType type) {
                           NSString *startTime = nil;
                           NSString *endTime = nil;
                           if (weakSelf.vehicleModel.type.integerValue == 2) {
                               // 是要续费的
                               startTime = weakSelf.vehicleModel.startTime;
                               NSDate *date = [XDUtil dateFromDateStr:weakSelf.vehicleModel.endTime WithFormatterStr:CarCharterDateFormatter];
                               endTime = [XDUtil getTimeStrSinceDate:date WithYear:0 month:type - 1000 day:0 formatterStr:CarCharterDateFormatter];
                           } else {
                               startTime = [XDUtil getNowTimeStrWithFormatter:CarCharterDateFormatter];
                               endTime = [XDUtil getTimeStrSinceNowWithYear:0 month:type - 1000 day:0 formatterStr:CarCharterDateFormatter];
                           }
                           XDDoPaymentController *payVC = [[XDDoPaymentController alloc] init];
                           XDCarCharterModel *charter = [[XDCarCharterModel alloc] init];
                           charter.fee = [weakSelf payStrWithType:type];
                           charter.startTime = startTime;
                           charter.endTime = endTime;
                           charter.plateNo = weakSelf.vehicleModel.plateNO;
                           payVC.charter = charter;
                           payVC.hasPaidBlock = ^{
                               tableView.tableFooterView = [UIView new];
                               weakSelf.vehicleModel.startTime = startTime;
                               weakSelf.vehicleModel.endTime = endTime;
                               weakSelf.vehicleModel.type = @"2";
                               weakSelf.vehicleModel.typeName = @"包期车";
                               [weakSelf.tableView reloadData];
                               if (weakSelf.addCarSuccess) {
                                   weakSelf.addCarSuccess();
                               }
                           };
                           [weakSelf.navigationController pushViewController:payVC animated:YES];
                       };
                   }
                   tableView.tableFooterView = weakSelf.selView;
               }
           };
           return cell;
       }
    XDCarPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDCarPropertyCell"];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)payStrWithType:(CarCharterType)type {
    if (type == CarCharterTypeMonthOne) {
        return @"218.00";
    } else if (type == CarCharterTypeMonthThree) {
        return @"618.00";
    } else if (type == CarCharterTypeMonthSix) {
        return @"1188.00";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDAddCarConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if (model.type == CarPropertyTypePlateNo) {
        return 80;
    } else if (model.type == CarPropertyTypePhoto) {
        return 120;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    XDAddCarConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"车牌颜色"]) {
        [self choiceItemWithBaseModel:model itemArray:self.plateColorArr];
    } else if ([model.title isEqualToString:@"车牌类型"]) {
        [self choiceItemWithBaseModel:model itemArray:self.plateTypeArr];
    } else if ([model.title isEqualToString:@"车辆颜色"]) {
        [self choiceItemWithBaseModel:model itemArray:self.carColorArr];
    } else if ([model.title isEqualToString:@"车辆类型"]) {
        [self choiceItemWithBaseModel:model itemArray:self.carTypeArr];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - lazy load
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSMutableArray *)plateColorArr {
    if (!_plateColorArr) {
        _plateColorArr = [NSMutableArray array];
    }
    return _plateColorArr;
}

- (NSMutableArray *)plateTypeArr {
    if (!_plateTypeArr) {
        _plateTypeArr = [NSMutableArray array];
    }
    return _plateTypeArr;
}

- (NSMutableArray *)carColorArr {
    if (!_carColorArr) {
        _carColorArr = [NSMutableArray array];
    }
    return _carColorArr;
}

- (NSMutableArray *)carTypeArr {
    if (!_carTypeArr) {
        _carTypeArr = [NSMutableArray array];
    }
    return _carTypeArr;
}

- (NSMutableDictionary *)parameter {
    if (!_parameter) {
        XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
        _parameter = [NSMutableDictionary dictionary];
        [_parameter setValue:loginInfo.userModel.mobile forKey:@"ownerPhone"];
        [_parameter setValue:loginInfo.userModel.currentDistrict.projectId forKey:@"projectId"];
        [_parameter setValue:loginInfo.userModel.userID forKey:@"householdId"];
    }
    return _parameter;
}

@end
