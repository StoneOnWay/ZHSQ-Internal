//
//  Created by cfsc on 2020/3/2.
//  Copyright © 2020年 zc. All rights reserved.
//

#import "XDFlowDetailController.h"
#import "XDFlowDetailHeaderView.h"
#import "XDFlowDetailCell.h"
#import "XDFlowDetailModel.h"
#import "XDOperationTableHeaderView.h"
#import "HZBaseListInfoTableViewCell.h"
#import "HZBaseAddImageTableViewCell.h"
#import "XDFlowOperationBtnView.h"
#import "XDFlowFormModel.h"
#import "XDFlowOperationModel.h"
#import "XDEventTableView.h"
#import "LMJDropdownMenu.h"
#import "XDEmployeeInfoModel.h"
#import "HWImagePickerSheet.h"
#import "XDEvaluateTableViewCell.h"
#import "HZSingleChoiceListView.h"
#import "HZPopView.h"
#import "WSDatePickerView.h"
#import "XDFlowProgressController.h"

@interface XDFlowDetailController ()
<
UITableViewDelegate,
UITableViewDataSource,
//LMJDropdownMenuDataSource,
//LMJDropdownMenuDelegate,
HZBaseAddImageTableViewCellDelegate,
HWImagePickerSheetDelegate
>

@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, strong) XDFlowDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 底部处理流程的tableView
@property (weak, nonatomic) IBOutlet XDEventTableView *operationTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationViewHeightConstaint;
@property (nonatomic, strong) XDOperationTableHeaderView *operationHeader;
@property (nonatomic, strong) NSMutableArray *formArray;
@property (nonatomic, assign) CGFloat formHeight;
// 流程处理参数
@property (nonatomic, strong) NSMutableDictionary *parameters;
@property (nonatomic, strong) NSMutableArray *directorArray;
@property (nonatomic, strong) NSMutableArray *employeeArray;
// 当前流程明细
@property (nonatomic, strong) XDFlowProcessModel *process;
// 照片数组
@property (strong, nonatomic) NSMutableArray <HZBaseImageModel *>*imageArray;
// 图片选择器
@property (strong, nonatomic) HWImagePickerSheet *imagePickerSheet;
// 原始图片资源数组
@property (strong, nonatomic) NSMutableArray *originALAssetArray;
// 资源的key
@property (nonatomic, strong) NSString *resourceKey;
// 紧急程度
@property (nonatomic, strong) NSMutableArray *emergencyArray;
// 当前选择时间
@property (nonatomic, copy) NSString *selectedTimeStr;

@end

@implementation XDFlowDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.resourceKey = @"";
    [self configTableView];
    [self getFlowDetailInfo];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"进度" style:UIBarButtonItemStyleDone target:self action:@selector(toProgressVC)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)toProgressVC {
    XDFlowProgressController *progressVC = [[XDFlowProgressController alloc] init];
    progressVC.flowDetail = self.detailModel;
    [self.navigationController pushViewController:progressVC animated:YES];
}

- (void)configTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"XDFlowDetailCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDFlowDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(XDFlowDetailHeaderView.class) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(XDFlowDetailHeaderView.class)];
    UITapGestureRecognizer *tapTableView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableViewAction)];
    tapTableView.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapTableView];
    // TODO:添加刷新控件
    
    // 默认隐藏底部处理视图
    self.formHeight = 0;
    [self setOperationViewHeight:self.formHeight];
    self.operationTableView.delegate = self;
    self.operationTableView.dataSource = self;
    [self.operationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HZBaseListInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HZBaseListInfoTableViewCell class])];
    [self.operationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HZBaseAddImageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HZBaseAddImageTableViewCell class])];
    [self.operationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDEvaluateTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDEvaluateTableViewCell class])];

    // 在UITableView上添加手势 隐藏键盘
    UITapGestureRecognizer *tapOperationTableView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    // 设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapOperationTableView.cancelsTouchesInView = NO;
    [self.operationTableView addGestureRecognizer:tapOperationTableView];
    self.operationTableView.scrollEnabled = NO;
}

- (void)tapTableViewAction {
    if (self.operationHeader.foldBlock) {
        self.operationHeader.foldBlock();
    }
    self.operationHeader.upfoldBtn.selected = NO;
    [self.view endEditing:YES];
}

- (void)configOperationTableHeaderFooter {
    WEAKSELF
    NSArray *contentArray = weakSelf.process.formContent;
    if (!contentArray || contentArray.count <= 0) {
        return;
    }
    // header
    XDOperationTableHeaderView *operationHeader = [[XDOperationTableHeaderView alloc] init];
    operationHeader.upfoldBtn.selected = YES;
    weakSelf.operationHeader = operationHeader;
    operationHeader.frame = CGRectMake(0, 0, kScreenWidth, 50);
    weakSelf.operationHeader.titleLabel.text = weakSelf.process.nodeName;
    operationHeader.upfoldBlock = ^{
        [weakSelf setOperationViewHeight:weakSelf.formHeight];
    };
    operationHeader.foldBlock = ^{
        [weakSelf setOperationViewHeight:50];
    };
    weakSelf.operationTableView.tableHeaderView = operationHeader;
    // footer
    XDFlowOperationBtnView *operationBtn = [XDFlowOperationBtnView loadFromNib];
    operationBtn.frame = CGRectMake(0, 0, kScreenWidth, 84.f);
    XDFlowFormModel *lastModel = weakSelf.process.formContent.lastObject;
    NSArray *btnLabelArray = [lastModel.formItemLabel componentsSeparatedByString:@","];
    if (btnLabelArray.count == 1) {
        [operationBtn setOperationBtnType:XDFlowOperationBtnTypeSingle];
        [operationBtn setSingleBtnTitle:btnLabelArray.firstObject];
        [operationBtn setClickOperationBlock:^(XDClickType clickType) {
            if (clickType == XDClickTypeCenter) {
                XDFlowOperationModel *operationModel = weakSelf.process.operationInfos.firstObject;
                // 提交
                [weakSelf configParameterWith:operationModel];
            }
        }];
    } else if (btnLabelArray.count == 2) {
        [operationBtn setOperationBtnType:XDFlowOperationBtnTypeDouble];
        [operationBtn setLeftBtnTitle:btnLabelArray[1]];
        [operationBtn setRightBtnTitle:btnLabelArray[0]];
        XDFlowOperationModel *refuse = nil;
        XDFlowOperationModel *accept = nil;
        for (XDFlowOperationModel *operation in weakSelf.process.operationInfos) {
            if ([operation.choose isEqualToString:@"0"]) {
                refuse = operation;
            } else if ([operation.choose isEqualToString:@"1"]) {
                accept = operation;
            }
        }
        [operationBtn setClickOperationBlock:^(XDClickType clickType) {
            if (clickType == XDClickTypeLeft) {
                // 拒绝
                [weakSelf configParameterWith:refuse];
            } else if (clickType == XDClickTypeRight) {
                // 接受
                [weakSelf configParameterWith:accept];
            }
        }];
    }
    self.operationTableView.tableFooterView = operationBtn;
}

// 根据内容初始化表单数据
- (void)showOperationView {
    WEAKSELF
    [weakSelf.formArray removeAllObjects];
    // 头尾固定高度
    weakSelf.formHeight = 50 + 84;
    NSArray *contentArray = weakSelf.process.formContent;
    if (!contentArray || contentArray.count <= 0) {
        return;
    }
    for (int i = 0; i < contentArray.count - 1; i++) {
        XDFlowFormModel *form = contentArray[i];
        HZBaseModel *model = [[HZBaseModel alloc] init];
        model.title = form.formItemLabel;
        model.type = form.formItemType;
        model.key = form.formKey;
        if ([form.formItemType isEqualToString:@"textarea"]) {
            model.baseType = HZBaseTypeTextView;
            weakSelf.formHeight += 127.f;
        } else if ([form.formItemType isEqualToString:@"pick_photo"]) {
            model.baseType = HZBaseTypeAddImage;
            model.value = weakSelf.imageArray;
            weakSelf.formHeight += (48 + (kScreenWidth - 30.f - 3 * 3.f) / 4);
        } else if ([form.formItemType isEqualToString:@"director"] || [form.formItemType isEqualToString:@"employee"] || [form.formItemType isEqualToString:@"emergency"] || [form.formItemType isEqualToString:@"pick_date"]) {
            if ([form.formItemType isEqualToString:@"director"]) {
                [self getDirectorList];
            } else if ([form.formItemType isEqualToString:@"employee"]) {
                [self getEmployeeList];
            }
            model.baseType = HZBaseTypeTextWithArrow;
            model.value = @"请选择";
            weakSelf.formHeight += 50.f;
        } else if ([form.formItemType isEqualToString:@"input_number"]) {
            model.baseType = HZBaseTypeTextField;
            weakSelf.formHeight += 50.f;
        } else if ([form.formItemType isEqualToString:@"rate"]) {
            model.baseType = HZBaseTypeEvaluate;
            weakSelf.formHeight += 50.f;
            // 默认五星
            [weakSelf.parameters setValue:@"5" forKey:model.key];
        } else if ([form.formItemType isEqualToString:@"text"]) {
            // 解析出需要从主表查到的值然后显示
            NSDictionary *dic = [weakSelf.detailModel mj_keyValuesWithKeys:@[form.fieldName]];
            model.value = dic[form.fieldName];
            model.baseType = HZBaseTypeText;
            weakSelf.formHeight += 50.f;
        }
        [weakSelf.formArray addObject:model];
    }
    [weakSelf.operationTableView reloadData];
    [weakSelf setOperationViewHeight:weakSelf.formHeight];
}

- (void)setOperationViewHeight:(CGFloat)height {
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.operationViewHeightConstaint.constant = height;
        [weakSelf.view layoutIfNeeded];
    }];
}

// 根据操作operationModel配置参数
- (void)configParameterWith:(XDFlowOperationModel *)operation {
    WEAKSELF
    [weakSelf.parameters setValue:[NSNumber numberWithString:operation.choose] forKey:@"choose"];
    [weakSelf.parameters setValue:operation.desc forKey:@"operationDesc"];
    [weakSelf.parameters setValue:operation.operationId forKey:@"operationId"];
    [weakSelf.parameters setValue:operation.name forKey:@"operationName"];
    [weakSelf commitFormData];
}

#pragma mark - Load Data & Commit
- (void)getFlowDetailInfo {
    [MBProgressHUD showActivityMessageInView:nil];
    WEAKSELF
    [XDHTTPRequst getFlowDetailWithFlowId:self.flow.flowId type:self.flowType succeed:^(NSDictionary *res) {
        if ([res[@"code"] integerValue] == 200) {
            weakSelf.detailModel = [XDFlowDetailModel mj_objectWithKeyValues:res[@"result"]];
            [weakSelf.tableView reloadData];
            XDFlowProcessModel *process = [weakSelf.detailModel.processes lastObject];
            weakSelf.process = process;
            if ([weakSelf isAssinged]) {
                [MBProgressHUD hideHUD];
                // 显示处理框
                [weakSelf showOperationView];
                [weakSelf configOperationTableHeaderFooter];
            } else {
                [MBProgressHUD hideHUD];
            }
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 是否流程当前处理人（业主端）
- (BOOL)isAssinged {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    NSString *userID = loginInfo.userModel.userID;
    if ([self.process.assigneeId isEqualToString:userID]) {
        return YES;
    } else {
        return NO;
    }
}

// 获取主管列表
- (void)getDirectorList {
    //    WEAKSELF
    //    [XDHTTPRequst getDirectorListSucceed:^(id res) {
    //        [MBProgressHUD hideHUD];
    //        if ([res[@"code"] integerValue] == 200) {
    //            [weakSelf.directorArray removeAllObjects];
    //            NSArray *array = res[@"result"];
    //            for (NSInteger i = 0; i < array.count; i++) {
    //                XDEmployeeInfoModel *model = [XDEmployeeInfoModel mj_objectWithKeyValues:array[i]];
    //                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
    //                singleChoiceModel.title = model.realName;
    //                singleChoiceModel.typeCode = model.employeeId;
    //                [weakSelf.directorArray addObject:singleChoiceModel];
    //            }
    //        } else {
    //            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
    //        }
    //    } fail:^(NSError *error) {
    //        NSLog(@"getDirectorList--%@", error);
    //        [MBProgressHUD hideHUD];
    //        [MBProgressHUD showTipMessageInView:@"服务器出错，请稍微再试！" timer:2];
    //    }];
    [self getAllEmployeeList];
}

// 获取员工列表
- (void)getEmployeeList {
    //    WEAKSELF
    //    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    //    if (!loginInfo.userModel.departId) {
    //        return;
    //    }
    //    [XDHTTPRequst getEmployeeListWithDepartIds:loginInfo.userModel.departId Succeed:^(id res) {
    //        [MBProgressHUD hideHUD];
    //        if ([res[@"code"] integerValue] == 200) {
    //            [weakSelf.employeeArray removeAllObjects];
    //            NSArray *array = res[@"result"];
    //            for (NSInteger i = 0; i < array.count; i++) {
    //                XDEmployeeInfoModel *model = [XDEmployeeInfoModel mj_objectWithKeyValues:array[i]];
    //                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
    //                singleChoiceModel.title = model.realName;
    //                singleChoiceModel.typeCode = model.employeeId;
    //                [weakSelf.employeeArray addObject:singleChoiceModel];
    //            }
    //        } else {
    //            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
    //        }
    //    } fail:^(NSError *error) {
    //        NSLog(@"getEmployeeList--%@", error);
    //        [MBProgressHUD hideHUD];
    //        [MBProgressHUD showTipMessageInView:@"服务器出错，请稍微再试！" timer:2];
    //    }];
    [self getAllEmployeeList];
}

// 分页获取员工列表（用于管理员账号登录）
- (void)getAllEmployeeList {
    WEAKSELF
    [XDHTTPRequst getEmployeeListSucceed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [weakSelf.employeeArray removeAllObjects];
            NSArray *array = res[@"result"][@"data"];
            for (NSInteger i = 0; i < array.count; i++) {
                XDEmployeeInfoModel *model = [XDEmployeeInfoModel mj_objectWithKeyValues:array[i]];
                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
                singleChoiceModel.title = model.realName;
                singleChoiceModel.typeCode = model.employeeId;
                [weakSelf.employeeArray addObject:singleChoiceModel];
                [weakSelf.directorArray addObject:singleChoiceModel];
            }
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        NSLog(@"getEmployeeList--%@", error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"服务器出错，请稍微再试！" timer:2];
    }];
}

// 表单校验
- (BOOL)verifyFormData {
    for (HZBaseModel *baseModel in self.formArray) {
        NSString *value = self.parameters[baseModel.key];
        // 校验不能为空的
        if (baseModel.required) {
            if (!value) {
                [XDUtil showToast:[NSString stringWithFormat:@"%@不能为空！", baseModel.title]];
                return NO;
            }
        }
        // 根据校验规则校验
        if (baseModel.valid && baseModel.valid.count > 0) {
            for (NSDictionary *dic in baseModel.valid) {
                if ([dic[@"type"] isEqualToString:@"Number"]) {
                    NSInteger min = [dic[@"min"] integerValue];
                    NSInteger max = [dic[@"max"] integerValue];
                    NSInteger intValue = value.integerValue;
                    // 非数字或者不在范围内
                    if ((![XDUtil isPureInt:value] && ![XDUtil isPureFloat:value]) || intValue < min || intValue > max) {
                        [XDUtil showToast:dic[@"message"]];
                        return NO;
                    }
                } else if ([dic[@"type"] isEqualToString:@"String"]) {
                    NSInteger minLength = [dic[@"minLength"] integerValue];
                    NSInteger maxLength = [dic[@"maxLength"] integerValue];
                    if (value.length < minLength || value.length > maxLength) {
                        [XDUtil showToast:dic[@"message"]];
                        return NO;
                    }
                }
            }
        }
    }
    // 校验特殊字符
    for (id value in self.parameters.allValues) {
        if (![value isKindOfClass:NSNumber.class] && ![value isEqualToString:@""]) {
            if (![XDUtil isLegalCharacter:value]) {
                [MBProgressHUD showTipMessageInView:@"请勿输入特殊字符！"];
                return NO;
            }
        }
    }
    return YES;
}

- (void)commitFormData {
    if (![self verifyFormData]) {
        return;
    };
    [MBProgressHUD showActivityMessageInView:nil];
    [self.parameters setValue:self.flow.flowId forKey:@"businessId"];
    WEAKSELF
    [XDHTTPRequst commitFlowDataWithDic:self.parameters type:self.flowType succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            // 移除上面的menu
            [weakSelf.operationTableView removeAllSubviews];
            // 清空提交参数
            [weakSelf.parameters removeObjectsForKeys:weakSelf.parameters.allKeys];
            // 清空之前请求的userList
            [weakSelf.directorArray removeAllObjects];
            [weakSelf.employeeArray removeAllObjects];
            weakSelf.resourceKey = @"";
            weakSelf.imageArray = nil;
            weakSelf.originALAssetArray = nil;
            // 让表单消失
            [weakSelf setOperationViewHeight:0];
            [weakSelf getFlowDetailInfo];
            // 刷新列表界面
            if (weakSelf.didUpdateFlowNode) {
                weakSelf.didUpdateFlowNode();
            }
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 上传照片到资源服务器
- (void)uploadFlowResouce:(NSData *)imageData {
    WEAKSELF
    [MBProgressHUD showActivityMessageInView:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"flowImage.jpg"];
    NSLog(@"flow image file path -- %@", filePath);
    [imageData writeToFile:filePath atomically:YES];
    [XDHTTPRequst uploadFileWithPath:filePath dic:@{@"resourceKey":weakSelf.resourceKey} name:@"UploadFile" succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            weakSelf.resourceKey = res[@"result"][@"resourceKey"];
            [weakSelf.parameters setValue:weakSelf.resourceKey forKey:@"resourceKey"];
            HZBaseImageModel *imageModel = [HZBaseImageModel new];
            imageModel.baseSourceType = HZBaseSourceTypeImageData;
            imageModel.source = imageData;
            [weakSelf.imageArray insertObject:imageModel atIndex:0];
            if (weakSelf.imageArray.count == 5) {
                [weakSelf.imageArray removeLastObject];
            }
            [weakSelf.operationTableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInView:res[@"message"] timer:2];
        }
    } fail:^(NSError *error) {
        NSLog(@"uploadFlowResouce--%@", error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:@"服务器出错，请稍微再试！" timer:2];
    }];
}

#pragma mark - tableViewDelegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.operationTableView) {
        return self.formArray.count;
    }
    return  self.detailModel.isFinish.integerValue == 1 ? self.detailModel.processes.count : self.detailModel.processes.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDFlowProcessModel *process = self.detailModel.processes[indexPath.row];
    if (tableView == self.operationTableView) {
        HZBaseModel *baseModel = self.formArray[indexPath.row];
        // estimate
        if (baseModel.baseType == HZBaseTypeTextView) {
            return 127.f;
        } else if (baseModel.baseType == HZBaseTypeAddImage) {
            // 图片collectionView高度 + 额外高度
            return 48 + (kScreenWidth - 30.f - 3 * 3.f) / 4;
        }
        return 50.f;
    }
    return [XDFlowDetailCell heightWithProcess:process];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.operationTableView) {
        HZBaseModel *baseModel = self.formArray[indexPath.row];
        // estimateFive
        if (baseModel.baseType == HZBaseTypeAddImage) {
            // 图片选择
            HZBaseAddImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZBaseAddImageTableViewCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            cell.itemArray = baseModel.value;
            return cell;
        }  else if (baseModel.baseType == HZBaseTypeEvaluate) {
            XDEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDEvaluateTableViewCell class]) forIndexPath:indexPath];
            @weakify(self)
            cell.textBlock = ^(NSString *text) {
                @strongify(self)
                [self.parameters setValue:text forKey:baseModel.key];
            };
            return cell;
        }
        HZBaseListInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZBaseListInfoTableViewCell class]) forIndexPath:indexPath];
        cell.baseModel = baseModel;
        // 下拉框
//        if (baseModel.baseType == HZBaseTypeTextWithDropDown) {
//            [self configDropDownView:cell];
//        }
        WEAKSELF
        // 输入框
        [cell setInputContentChangeBlock:^(NSString *content) {
            baseModel.value = content;
            [weakSelf.parameters setValue:content forKey:baseModel.key];
        }];
        return cell;
    }
    XDFlowProcessModel *model = self.detailModel.processes[indexPath.row];
//    XDFlowDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDFlowDetailCell"];
    // 复用tableViewCell会导致其collecitonView加载出问题
    XDFlowDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"XDFlowDetailCell" owner:nil options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.processModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.operationTableView) {
        HZBaseModel *baseModel = self.formArray[indexPath.row];
        if (baseModel.baseType == HZBaseTypeTextWithArrow) {
            // 选择的类型
            if ([baseModel.type isEqualToString:@"emergency"]) {
                [self choiceItemWithBaseModel:baseModel itemArray:self.emergencyArray];
            } else if ([baseModel.type isEqualToString:@"director"]) {
                [self choiceItemWithBaseModel:baseModel itemArray:self.directorArray];
            } else if ([baseModel.type isEqualToString:@"employee"]) {
                [self choiceItemWithBaseModel:baseModel itemArray:self.employeeArray];
            } else if ([baseModel.type isEqualToString:@"pick_date"]) {
                [self choiceTime:self.selectedTimeStr baseModel:baseModel];
            }
        }
    }
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
        baseModel.value = singleChioceModel.title;
        [self.operationTableView reloadData];
        [popView diss];
        popView = nil;
        [self.parameters setValue:singleChioceModel.typeCode forKey:baseModel.key];
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
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowData = [dateformater dateFromString:time];
    @weakify(self)
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay withUnitData:nowData CompleteBlock:^(NSDate *startDate) {
        @strongify(self)
        NSString *timeStr = [startDate stringWithFormat:@"yyyy-MM-dd"];
        self.selectedTimeStr = timeStr;
        baseModel.value = timeStr;
        [self.parameters setValue:timeStr forKey:baseModel.key];
        [self.operationTableView reloadData];
    }];
    datepicker.doneButtonColor = UIColorHex(007cc2); // 确定按钮的颜色
    [datepicker show];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.operationTableView) {
        return nil;
    }
    XDFlowDetailHeaderView *headerView = [[XDFlowDetailHeaderView alloc] init];
    headerView.model = self.detailModel;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.operationTableView) {
        return 0;
    }
    CGFloat height = [XDFlowDetailHeaderView heigtForViewWithFlowDetail:self.detailModel];
    return self.detailModel.flowType.integerValue == 2 ? height - 30 : height;
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

#pragma mark - LMJDropdownMenu
/*
- (void)configDropDownView:(HZBaseListInfoTableViewCell *)cell {
    LMJDropdownMenu *menu = [[LMJDropdownMenu alloc] init];
    menu.dataSource = self;
    menu.delegate = self;
    menu.layer.cornerRadius = 3;
    menu.title = @"请选择";
    menu.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    menu.titleTextFont = [UIFont systemFontOfSize:14];
    menu.titleColor = RGB(120, 120, 120);
    menu.rotateIcon = [UIImage imageNamed:@"btn_public_down"];
    menu.rotateIconSize  = CGSizeMake(14, 8);
    menu.optionBgColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
    menu.optionFont = [UIFont systemFontOfSize:13];
    menu.optionTextColor = RGB(120, 120, 120);
    menu.optionTextAlignment = NSTextAlignmentLeft;
    menu.optionNumberOfLines = 0;
    menu.optionLineColor = [UIColor whiteColor];
    menu.optionIconSize = CGSizeMake(15, 15);
    CGRect rect = [cell convertRect:cell.frame toView:self.operationTableView];
    CGRect menuRect = CGRectMake(66.f, rect.origin.y - 50, kScreenWidth - 76, 50);
    menu.frame = menuRect;
    [self.operationTableView addSubview:menu];
}

- (NSUInteger)numberOfOptionsInDropdownMenu:(LMJDropdownMenu *)menu{
    return self.directorArray.count;
}
- (CGFloat)dropdownMenu:(LMJDropdownMenu *)menu heightForOptionAtIndex:(NSUInteger)index{
    return 42;
}
- (NSString *)dropdownMenu:(LMJDropdownMenu *)menu titleForOptionAtIndex:(NSUInteger)index{
    XDEmployeeInfoModel *model = self.directorArray[index];
    return model.realName;
}

- (void)dropdownMenu:(LMJDropdownMenu *)menu didSelectOptionAtIndex:(NSUInteger)index optionTitle:(NSString *)title {
    XDEmployeeInfoModel *model = self.directorArray[index];
    [self.parameters setValue:model.employeeId forKey:@"assignId"];
}
*/
 
#pragma mark - 键盘出现 & 消失
- (void)keyboardWillShow:(NSNotification *)note {
    [self setOperationViewHeight:self.operationTableView.contentSize.height];
    NSDictionary *userInfo = [note userInfo];
    // get keyboard rect in windwo coordinate
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // convert keyboard rect from window coordinate to scroll view coordinate
    keyboardRect = [self.operationTableView convertRect:keyboardRect fromView:nil];
    // get first responder textfield
    UIView *currentResponder = [self findFirstResponderBeneathView:self.operationTableView];
    if (currentResponder != nil) {
        CGPoint point = [currentResponder convertPoint:CGPointMake(0, currentResponder.frame.size.height) toView:self.operationTableView];
        // 计算textfield左下角和键盘上面20像素 之间是不是差值
        float scrollY = point.y - (keyboardRect.origin.y - 5);
        NSLog(@"scrollY---%f", scrollY);
        if (scrollY > 0) {
            // 这里+的0代表textField左下角和键盘的距离
            CGFloat contentHeight = self.operationTableView.contentSize.height + scrollY + 0;
            [self setOperationViewHeight:contentHeight];
        }
    }
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for (UIView *childView in view.subviews) {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder]) return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

- (void)keyboardWillHide:(NSNotification *)note {
    [self setOperationViewHeight:self.operationTableView.contentSize.height];
}

- (void)hideKeyBoard {
    [self.operationTableView endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)detailArray {
    if (!_detailArray) {
        _detailArray = [[NSMutableArray alloc] init];
    }
    return _detailArray;
}

- (XDFlowDetailModel *)detailModel {
    if (!_detailModel) {
        _detailModel = [[XDFlowDetailModel alloc] init];
    }
    return _detailModel;
}

- (NSMutableArray *)formArray {
    if (!_formArray) {
        _formArray = [[NSMutableArray alloc] init];
    }
    return _formArray;
}

- (NSMutableArray *)directorArray {
    if (!_directorArray) {
        _directorArray = [[NSMutableArray alloc] init];
    }
    return _directorArray;
}

- (NSMutableArray *)employeeArray {
    if (!_employeeArray) {
        _employeeArray = [[NSMutableArray alloc] init];
    }
    return _employeeArray;
}

- (NSMutableArray *)emergencyArray {
    if (!_emergencyArray) {
        _emergencyArray = [NSMutableArray array];
        NSArray *array = @[
                           @{@"非常紧急":@"1"},
                           @{@"紧急":@"2"},
                           @{@"一般":@"3"},
                           @{@"低":@"4"},
                           @{@"可以忽略":@"5"}
                           ];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dic = array[i];
            HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
            singleChoiceModel.title = dic.allKeys.firstObject;
            singleChoiceModel.typeCode = dic.allValues.firstObject;
            [_emergencyArray addObject:singleChoiceModel];
        }
    }
    return _emergencyArray;
}

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
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
