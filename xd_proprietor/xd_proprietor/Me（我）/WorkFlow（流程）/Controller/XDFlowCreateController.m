//
//  Created by cfsc on 2020/4/7.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDFlowCreateController.h"
#import "HZBaseListInfoTableViewCell.h"
#import "HZBaseAddImageTableViewCell.h"
#import "XDFlowOperationBtnView.h"
#import "HWImagePickerSheet.h"
#import "WSDatePickerView.h"
#import "GSPopoverViewController.h"
#import "HZSingleChoiceListView.h"
#import "HZPopView.h"

@interface XDFlowCreateController ()
<
UITableViewDelegate,
UITableViewDataSource,
HZBaseAddImageTableViewCellDelegate,
HWImagePickerSheetDelegate
>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *itemArray;
// 工单类型Type数据
@property(nonatomic, strong) NSMutableArray *repairTypeArray;
@property (nonatomic, copy) NSString *repairTime;
// 投诉类型
@property(nonatomic, strong) NSMutableArray *complainTypeArray;
// 请求参数
@property (strong, nonatomic) NSMutableDictionary *parameter;
// 照片数组
@property (strong, nonatomic) NSMutableArray <HZBaseImageModel *>*imageArray;
// 图片选择器
@property (strong, nonatomic) HWImagePickerSheet *imagePickerSheet;
// 原始图片资源数组
@property (strong, nonatomic) NSMutableArray *originALAssetArray;
// 资源的key
@property (nonatomic, strong) NSString *resourceKey;

@end

@implementation XDFlowCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.title containsString:@"报事报修"]) {
        self.type = XDFlowCreateControllerTypeOrder;
        [self getOrderTypeList];
    } else if ([self.title containsString:@"投诉建议"]) {
        self.type = XDFlowCreateControllerTypeComplain;
        [self getComplainTypeList];
    }
    self.resourceKey = @"";
    [self setUpUI];
    [self configDataSource];
}

- (void)setUpUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavHeight)];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = UIColorHex(f3f3f3);
    tableView.estimatedRowHeight = 40.f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HZBaseListInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HZBaseListInfoTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HZBaseAddImageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HZBaseAddImageTableViewCell class])];
//    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDEvaluateTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDEvaluateTableViewCell class])];
    
    UITapGestureRecognizer *tapTableView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableViewAction)];
    tapTableView.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapTableView];
    
    XDFlowOperationBtnView *operationBtn = [XDFlowOperationBtnView loadFromNib];
    operationBtn.frame = CGRectMake(0, 0, kScreenWidth, 102.f);
    [operationBtn setOperationBtnType:XDFlowOperationBtnTypeSingle];
    [operationBtn setSingleBtnTitle:@"提交"];
    operationBtn.backgroundColor = UIColorHex(f3f3f3);
    @weakify(self)
    [operationBtn setClickOperationBlock:^(XDClickType clickType) {
        @strongify(self)
        if (self.type == XDFlowCreateControllerTypeOrder) {
            [self createOrder];
        } else if (self.type == XDFlowCreateControllerTypeComplain) {
            [self createComplain];
        } else if (self.type == XDFlowCreateControllerTypeFilter) {
            [self handleFilter];
        } else if (self.type == XDFlowCreateControllerTypeEvaluate) {
            [self commitEvaluate];
        }
    }];
    tableView.tableFooterView = operationBtn;
}

- (void)tapTableViewAction {
    [self.view endEditing:YES];
}

- (void)configDataSource {
    [self.itemArray removeAllObjects];
    
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    XDUserCurrentDistrictModel *currentDistrict = loginInfo.userModel.currentDistrict;
    if (self.type == XDFlowCreateControllerTypeOrder) {
        // 工单
        HZBaseModel *roomBaseModel = [[HZBaseModel alloc] init];
        roomBaseModel.title = @"业主房屋：";
        NSString *fullName = [NSString stringWithFormat:@"%@-%@-%@-%@", currentDistrict.phaseName, currentDistrict.buildingName, currentDistrict.unitName, currentDistrict.roomName];
        roomBaseModel.baseType = HZBaseTypeText;
        roomBaseModel.value = fullName;
        [self configEditWithBaseModel:roomBaseModel code:fullName];
        
        HZBaseModel *addressBaseModel = [[HZBaseModel alloc] init];
        addressBaseModel.title = @"维修地点：";
        addressBaseModel.baseType = HZBaseTypeTextField;
        addressBaseModel.value = [NSString stringWithFormat:@"%@%@", currentDistrict.projectName, fullName];
        [self configEditWithBaseModel:roomBaseModel code:addressBaseModel.value];
        
        HZBaseModel *timeBaseModel = [[HZBaseModel alloc] init];
        timeBaseModel.title = @"上门时间：";
        NSString *currentTime = [XDUtil getNowTimeStrWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
        self.repairTime = currentTime;
        timeBaseModel.value = currentTime;
        timeBaseModel.baseType = HZBaseTypeTextWithArrow;
        [self configEditWithBaseModel:timeBaseModel code:currentTime];
        
        HZBaseModel *contactModel = [[HZBaseModel alloc] init];
        contactModel.title = @"联系人员：";
        contactModel.baseType = HZBaseTypeTextField;
        contactModel.value = loginInfo.userModel.name ? loginInfo.userModel.name : @"";
        [self configEditWithBaseModel:contactModel code:contactModel.value];
        
        HZBaseModel *contactMobileModel = [[HZBaseModel alloc] init];
        contactMobileModel.title = @"联系电话：";
        contactMobileModel.baseType = HZBaseTypeTextField;
        contactMobileModel.value = loginInfo.userModel.mobile ? loginInfo.userModel.mobile : @"";
        [self configEditWithBaseModel:contactMobileModel code:contactMobileModel.value];
        
        HZBaseModel *repairTypeBaseModel = [[HZBaseModel alloc] init];
        repairTypeBaseModel.title = @"工单类型：";
        HZSingleChoiceModel *firstModel = self.repairTypeArray.firstObject;
        repairTypeBaseModel.value = firstModel.title;
        repairTypeBaseModel.baseType = HZBaseTypeTextWithArrow;
        [self configEditWithBaseModel:repairTypeBaseModel code:firstModel.typeCode];
        
        HZBaseModel *problemDescriptionBaseModel = [[HZBaseModel alloc] init];
        problemDescriptionBaseModel.title = @"问题描述：";
        problemDescriptionBaseModel.baseType = HZBaseTypeTextView;
        
        HZBaseModel *imageBaseModel = [[HZBaseModel alloc] init];
        imageBaseModel.title = @"上传图片：";
        imageBaseModel.value = self.imageArray;
        imageBaseModel.baseType = HZBaseTypeAddImage;
        
        [self.itemArray addObject:@[roomBaseModel, addressBaseModel, timeBaseModel, contactModel, contactMobileModel, repairTypeBaseModel]];
        [self.itemArray addObject:@[problemDescriptionBaseModel, imageBaseModel]];
    } else if (self.type == XDFlowCreateControllerTypeComplain) {
        // 投诉
        HZBaseModel *complainTypeModel = [[HZBaseModel alloc] init];
        complainTypeModel.title = @"投诉类型：";
        HZSingleChoiceModel *firstModel = self.complainTypeArray.firstObject;
        complainTypeModel.value = firstModel.title;
        complainTypeModel.baseType = HZBaseTypeTextWithArrow;
        [self configEditWithBaseModel:complainTypeModel code:firstModel.typeCode];
        
        HZBaseModel *problemDescriptionBaseModel = [[HZBaseModel alloc] init];
        problemDescriptionBaseModel.title = @"投诉内容：";
        problemDescriptionBaseModel.baseType = HZBaseTypeTextView;
        
        HZBaseModel *imageBaseModel = [[HZBaseModel alloc] init];
        imageBaseModel.title = @"上传图片：";
        imageBaseModel.value = self.imageArray;
        imageBaseModel.baseType = HZBaseTypeAddImage;
        
        [self.itemArray addObject:@[complainTypeModel]];
        [self.itemArray addObject:@[problemDescriptionBaseModel, imageBaseModel]];
    }
    
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
    HZBaseModel *baseModel = self.itemArray[indexPath.section][indexPath.row];
    if (baseModel.baseType == HZBaseTypeTextView) {
        return 127.f;
    } else if (baseModel.baseType == HZBaseTypeAddImage) {
        // 图片collectionView高度 + 额外高度
        return 48 + (kScreenWidth - 30.f - 3 * 3.f) / 4;
    }
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HZBaseModel *baseModel = self.itemArray[indexPath.section][indexPath.row];
    if (baseModel.baseType == HZBaseTypeAddImage) {
        HZBaseAddImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZBaseAddImageTableViewCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.itemArray = baseModel.value;
        return cell;
    }
    HZBaseListInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZBaseListInfoTableViewCell class]) forIndexPath:indexPath];
    cell.baseModel = baseModel;
    @weakify(self)
    [cell setInputContentChangeBlock:^(NSString *content) {
        @strongify(self)
        baseModel.value = content;
        [self configEditWithBaseModel:baseModel code:content];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HZBaseModel *baseModel = self.itemArray[indexPath.section][indexPath.row];
    if (baseModel.baseType == HZBaseTypeTextWithArrow) {
        if (self.type == XDFlowCreateControllerTypeOrder) {
            if ([baseModel.title isEqualToString:@"上门时间："]) {
                [self choiceTime:self.repairTime baseModel:baseModel];
            } else if ([baseModel.title isEqualToString:@"工单类型："]) {
                [self choiceItemWithBaseModel:baseModel itemArray:self.repairTypeArray];
            }
        } else if (self.type == XDFlowCreateControllerTypeComplain) {
            if ([baseModel.title isEqualToString:@"投诉类型："]) {
                [self choiceItemWithBaseModel:baseModel itemArray:self.complainTypeArray];
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return DBL_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 8.f;
    }
    return DBL_EPSILON;
}

#pragma mark - 选择器
- (void)choiceItemWithBaseModel:(HZBaseModel *)baseModel itemArray:(NSArray *)itemArray{
    __block HZPopView *popView = [HZPopView new];
    CGFloat width = 300.f * kScreenWidth / 375.f;
    
    HZSingleChoiceListView *singleChoiceView = [HZSingleChoiceListView new];
    singleChoiceView.itemArray = [itemArray copy];
    @weakify(self)
    [singleChoiceView setChoiceResultBlock:^(id result) {
        @strongify(self)
        HZSingleChoiceModel *singleChioceModel = result;
        baseModel.value =singleChioceModel.title;
        [self.tableView reloadData];
        [popView diss];
        popView = nil;
        
        [self configEditWithBaseModel:baseModel code:singleChioceModel.typeCode];
    }];
    
    [singleChoiceView setChoiceDismissBlock:^{
        [popView diss];
        popView = nil;
    }];
    [popView popViewWithContenView:singleChoiceView inRect:CGRectMake(0, 0, width, width * 5.f / 6) inContainer:nil];
}

// 时间选择
- (void)choiceTime:(NSString *)time baseModel:(HZBaseModel *)baseModel {
    [self.view endEditing:YES];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowData = [dateformater dateFromString:time];
    @weakify(self)
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute withUnitData:nowData CompleteBlock:^(NSDate *startDate) {
        @strongify(self)
        self.repairTime = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        baseModel.value = self.repairTime;
        [self configEditWithBaseModel:baseModel code:baseModel.value];
        [self.tableView reloadData];
    }];
    datepicker.doneButtonColor = UIColorHex(007cc2); // 确定按钮的颜色
    [datepicker show];
}

#pragma mark - Request
- (void)createOrder {
    for (id value in self.parameter.allValues) {
        if (![value isKindOfClass:NSNumber.class]) {
            if (![XDUtil isLegalCharacter:value]) {
                [MBProgressHUD showTipMessageInView:@"请勿输入特殊字符！"];
                return;
            }
        }
    }
    if (!self.parameter[@"problemDesc"]) {
        [MBProgressHUD showTipMessageInView:@"请填写问题描述！"];
        return;
    }
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst createOrderWithDic:self.parameter succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [MBProgressHUD showTipMessageInWindow:@"创建工单成功" timer:1];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)createComplain {
    for (id value in self.parameter.allValues) {
        if (![value isKindOfClass:NSNumber.class]) {
            if (![XDUtil isLegalCharacter:value]) {
                [MBProgressHUD showTipMessageInView:@"请勿输入特殊字符！"];
                return;
            }
        }
    }
    if (!self.parameter[@"problemDesc"]) {
        [MBProgressHUD showTipMessageInView:@"请填写投诉内容！"];
        return;
    }
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst createComplainWithDic:self.parameter succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [MBProgressHUD showTipMessageInWindow:@"创建投诉成功" timer:1];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

- (void)handleFilter {
    
}

- (void)commitEvaluate {
    
}

// 上传照片到资源服务器
- (void)uploadFlowResouce:(NSData *)imageData {
    [MBProgressHUD showActivityMessageInView:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"flowImage.jpg"];
    NSLog(@"face image file path -- %@", filePath);
    [imageData writeToFile:filePath atomically:YES];
    @weakify(self)
    [XDHTTPRequst uploadFileWithPath:filePath dic:@{@"resourceKey":self.resourceKey} name:@"UploadFile" succeed:^(id res) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            self.resourceKey = res[@"result"][@"resourceKey"];
            [self.parameter setValue:self.resourceKey forKey:@"problemResourceKey"];
            HZBaseImageModel *imageModel = [HZBaseImageModel new];
            imageModel.baseSourceType = HZBaseSourceTypeImageData;
            imageModel.source = imageData;
            [self.imageArray insertObject:imageModel atIndex:0];
            if (self.imageArray.count == 5) {
                [self.imageArray removeLastObject];
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        NSLog(@"uploadFlowResouce--%@", error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"服务器出错，请稍微再试！" timer:2];
    }];
}

// 获取工单类型列表
- (void)getOrderTypeList {
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@100
                          };
    @weakify(self);
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst getOrderTypeListWithDic:dic succeed:^(id res) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [self.repairTypeArray removeAllObjects];
            NSArray *array = res[@"result"][@"data"];
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
                singleChoiceModel.title = dic[@"name"];
                singleChoiceModel.typeCode = dic[@"id"];
                singleChoiceModel.selectedStatus = (i == 0);
                [self.repairTypeArray addObject:singleChoiceModel];
            }
            [self configDataSource];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 获取投诉类型列表
- (void)getComplainTypeList {
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@100
                          };
    @weakify(self);
    [MBProgressHUD showActivityMessageInView:nil];
    [XDHTTPRequst getComplainTypeListWithDic:dic succeed:^(id res) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [self.complainTypeArray removeAllObjects];
            NSArray *array = res[@"result"][@"data"];
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
                singleChoiceModel.title = dic[@"name"];
                singleChoiceModel.typeCode = dic[@"id"];
                singleChoiceModel.selectedStatus = (i == 0);
                [self.complainTypeArray addObject:singleChoiceModel];
            }
            [self configDataSource];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

#pragma mark - 工具方法
// 接收选择或输入数据
- (void)configEditWithBaseModel:(HZBaseModel *)baseModel code:(NSString *)code {
    NSString *key = [self keyChange:baseModel.title];
    if ([key containsString:@"|"] && [code containsString:@"|"]) {
        NSArray *keyArray = [key componentsSeparatedByString:@"|"];
        NSArray *codeArray = [code componentsSeparatedByString:@"|"];
        [self configParameterWithKey:keyArray.firstObject value:codeArray.firstObject];
        [self configParameterWithKey:keyArray.lastObject value:codeArray.lastObject];
    } else {
        [self configParameterWithKey:key value:code];
    }
}

- (void)configParameterWithKey:(NSString *)key value:(NSString *)value {
    if ([key isEqualToString:@""] || key.length <= 0) {
        return;
    }
    if ([self.parameter.allKeys containsObject:key]) {
        [self.parameter setObject:value forKey:key];
    } else {
        self.parameter[key] = value;
    }
}

- (NSString *)keyChange:(NSString *)key {
    if (self.type == XDFlowCreateControllerTypeOrder) {
        NSDictionary *dic = @{
                              @"业主房屋" : @"roomId",
                              @"维修地点：" : @"address",
                              @"上门时间：" : @"expectTime",
                              @"联系人员：" : @"linkMan",
                              @"联系电话：" : @"mobile",
                              @"工单类型：" : @"typeId",
                              @"问题描述：" : @"problemDesc",
                              };
        return dic[key];
    } else if (self.type == XDFlowCreateControllerTypeComplain) {
        NSDictionary *dic = @{
                              @"投诉类型：" : @"typeId",
                              @"投诉内容：" : @"problemDesc"
                              };
        return dic[key];
    } else if (self.type == XDFlowCreateControllerTypeFilter) {
        NSDictionary *dic = @{
                              @"开始时间：" : @"startTime",
                              @"结束时间：" : @"endTime",
                              @"工单类别：" : @"workOrderType",
                              @"投诉类别：" : @"complainTypeId",
                              };
        return dic[key];
    } else if (self.type == XDFlowCreateControllerTypeEvaluate) {
        NSDictionary *dic = @{
                              @"评分：" : @"commentLevel",
                              @"评价内容：" : @"commentContent",
                              };
        return dic[key];
    }
    return @"";
}

#pragma mark - 照片选择
- (void)pickerPhoto:(UIView *)view {
    //    if (self.originALAssetArray.count) {
    //        self.imagePickerSheet.arrSelected = [self.originALAssetArray mutableCopy];
    //        self.imagePickerSheet.arrSelected = [NSMutableArray array];
    //    }
    self.imagePickerSheet.arrSelected = [NSMutableArray array];
    [self.imagePickerSheet showImgPickerActionSheetInView:self popoverView:view];
}

- (void)deleteItemWithImageModel:(HZBaseImageModel *)imageModel indexPath:(NSIndexPath *)indexPath {
    //    [self.imageArray removeObject:imageModel];
    //    [self.originALAssetArray removeObjectAtIndex:indexPath.row];
    //    if (self.imageArray.count < 4) {
    //        HZBaseImageModel *baseImageModel = self.imageArray.lastObject;
    //        if (baseImageModel.source != nil) {
    //            HZBaseImageModel *imageModel = [HZBaseImageModel new];
    //            imageModel.source = nil;
    //            imageModel.baseSourceType = HZBaseSourceTypeNone;
    //            [self.imageArray addObject:imageModel];
    //        }
    //    }
    //    [self.operationTableView reloadData];
}

- (void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray {
    //    [self.originALAssetArray removeAllObjects];
    //    [self.originALAssetArray addObjectsFromArray:[NSMutableArray arrayWithArray:ALAssetArray]];
    
    if (ALAssetArray.count) {
        NSArray *imageDataArray = [[self getBigImageArrayWithALAssetArray:ALAssetArray] copy];
        [self uploadFlowResouce:imageDataArray[0]];
    }
}

//获得大图
- (NSArray*)getBigImageArrayWithALAssetArray:(NSArray*)ALAssetArray {
    NSMutableArray *bigImgDataArray = [NSMutableArray array];
    for (int i = 0; i<ALAssetArray.count; i++) {
        if ([ALAssetArray[i] isKindOfClass:[UIImage class]]) {
            UIImage *img = ALAssetArray[i];
            NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
            imageData = [KYCompressImage compressImage:imageData toByte:60*1024];
            [bigImgDataArray addObject:imageData];
        }else {
            ALAsset *set = ALAssetArray[i];
            if ([self getBigIamgeDataWithALAsset:set]) {
                [bigImgDataArray addObject:[self getBigIamgeDataWithALAsset:set]];
            }
        }
    }
    return bigImgDataArray;
}

- (NSData *)getBigIamgeDataWithALAsset:(ALAsset*)set{
    // 需传入方向和缩放比例，否则方向和尺寸都不对
    // warning:这里经常o有些图片得到空的对象
    //    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage
    //                                       scale:set.defaultRepresentation.scale
    //                                 orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    //    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    CGImageRef cgImg = [set aspectRatioThumbnail];
    UIImage* image = [UIImage imageWithCGImage: cgImg];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    imageData = [KYCompressImage compressImage:imageData toByte:60*1024];
    return imageData;
}

#pragma mark - 懒加载
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSMutableArray *)repairTypeArray {
    if (!_repairTypeArray) {
        _repairTypeArray = [NSMutableArray array];
        HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
        singleChoiceModel.title = @"入室维修";
        singleChoiceModel.typeCode = @"1";
        singleChoiceModel.selectedStatus = YES;
        [_repairTypeArray addObject:singleChoiceModel];
    }
    return _repairTypeArray;
}

- (NSMutableArray *)complainTypeArray {
    if (!_complainTypeArray) {
        _complainTypeArray = [NSMutableArray array];
        HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
        singleChoiceModel.title = @"物业投诉";
        singleChoiceModel.typeCode = @"1";
        singleChoiceModel.selectedStatus = YES;
        [_complainTypeArray addObject:singleChoiceModel];
    }
    return _complainTypeArray;
}

- (NSMutableDictionary *)parameter {
    if (!_parameter) {
        XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
        _parameter = [NSMutableDictionary dictionary];
        [_parameter setValue:@1 forKey:@"createType"];
        [_parameter setValue:loginInfo.userModel.userID forKey:@"householdId"];
        [_parameter setValue:loginInfo.userModel.currentDistrict.projectId forKey:@"projectId"];
        [_parameter setValue:loginInfo.userModel.currentDistrict.roomId forKey:@"roomId"];
        [_parameter setValue:@1 forKey:@"reportType"];
    }
    return _parameter;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        HZBaseImageModel *baseImageModel = [[HZBaseImageModel alloc] init];
        baseImageModel.source = @"";
        baseImageModel.baseSourceType = HZBaseSourceTypeNone;
        [_imageArray addObject:baseImageModel];
    }
    return _imageArray;
}

- (HWImagePickerSheet *)imagePickerSheet {
    if (!_imagePickerSheet) {
        _imagePickerSheet = [HWImagePickerSheet new];
        _imagePickerSheet.delegate = self;
    }
    return _imagePickerSheet;
}

- (NSMutableArray *)originALAssetArray {
    if (!_originALAssetArray) {
        _originALAssetArray = [NSMutableArray array];
    }
    return _originALAssetArray;
}

@end
