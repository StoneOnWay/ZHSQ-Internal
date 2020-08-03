//
//  XDFaceManageController.m
//  xd_proprietor
//
//  Created by stone on 23/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDFaceManageController.h"
#import "XDImagePickerController.h"
#import "XDOverlayView.h"
#import "XDDevicePermissionController.h"
#import "XDCommunityPermissionModel.h"

@interface XDFaceManageController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, XDOverlayViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) XDOverlayView *overlay;
@property (nonatomic, strong) NSMutableArray *permissionArray;
@property (nonatomic, copy) NSString *errorTipStr;

@end

@implementation XDFaceManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人脸下发";
    self.photoBtn.hidden = YES;
    self.errorTipStr = @"";
    [self setUpFaceImageView];
    [self loadFaceImage];
}

- (void)setUpFaceImageView {
    self.faceImageView.layer.cornerRadius = self.faceImageView.frame.size.width / 2;
    self.faceImageView.layer.masksToBounds = YES;
}

- (void)loadFaceImage {
    if (!self.userModel.faceId) {
        [self.photoBtn setTitle:@"拍照并上传我的人脸" forState:(UIControlStateNormal)];
        self.stateLabel.text = @"人脸照片尚未上传";
        self.photoBtn.hidden = NO;
    } else {
        self.stateLabel.text = @"人脸上传时间";
        self.timeLabel.text = self.userModel.faceResource.createTime;
        [self.photoBtn setTitle:@"重新上传" forState:(UIControlStateNormal)];
        [self.faceImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.faceResource.url] placeholderImage:[UIImage imageNamed:@"moren_tx_hui"]];
        // 获取所有设备权限下发状态
        [self getAllDevicePermissions];
    }
}

- (void)getAllDevicePermissions {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (!loginInfo.userModel.currentDistrict.projectId || !self.phaseId || !self.userModel.userID) {
        return;
    }
    NSDictionary *dic = @{
        @"projectId":loginInfo.userModel.currentDistrict.projectId,
        @"phaseId":self.phaseId,
        @"personId":self.userModel.userID
    };
    [XDHTTPRequst getAllPermissionsListWithDic:dic succeed:^(id res) {
        if ([res[@"code"] integerValue] == 200) {
            self.permissionArray = [XDCommunityPermissionModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
            [self showErrorWithPermission];
            self.photoBtn.hidden = NO;
        }
    } fail:^(NSError *error) {
        [XDHTTPRequst showErrorMessageWith:error];
    }];
}

// 根据人员物联下发状态提示是否前往单独下发界面
- (void)showErrorWithPermission {
    for (XDCommunityPermissionModel *model in self.permissionArray) {
        if (model.faceStatus.integerValue != 1) {
            if (self.errorTipStr.length == 0) {
                self.errorTipStr = model.deviceName;
            } else {
                self.errorTipStr = [NSString stringWithFormat:@"%@、%@", self.errorTipStr, model.deviceName];
            }
        }
    }
    if (self.errorTipStr.length != 0) {
        NSString *str = [NSString stringWithFormat:@"%@等设备的人脸未正常下发，为了保证人脸识别功能正常使用，请重新下发人脸", self.errorTipStr];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"暂不下发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"前往下发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [self showDetail];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)showDetail {
    XDDevicePermissionController *permissionVC = [[XDDevicePermissionController alloc] init];
    permissionVC.errorTipStr = self.errorTipStr;
    permissionVC.permissionArray = self.permissionArray;
    permissionVC.userModel = self.userModel;
    permissionVC.roomId = self.roomId;
    permissionVC.phaseId = self.phaseId;
    [self.navigationController pushViewController:permissionVC animated:YES];
}

- (IBAction)photoAction:(id)sender {
    XDImagePickerController *picker = [[XDImagePickerController alloc] init];
    if ([XDImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.showsCameraControls = NO;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        XDOverlayView *overlay = [[XDOverlayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.overlay = overlay;
        overlay.picker = picker;
        overlay.delegate = self;
        picker.cameraOverlayView = overlay;
        picker.cameraOverlayView.frame = [UIScreen mainScreen].bounds;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

// 上传照片到资源服务器
- (void)uploadFace:(UIImage *)image {
    if (!self.unitId || !self.phaseId) {
        return;
    }
    @weakify(self)
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    [MBProgressHUD showActivityMessageInView:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"flowImage.jpg"];
    NSLog(@"flow image file path -- %@", filePath);
    NSData *imageData = [image compressBySize:CGSizeMake(960, 1280) WithMaxLength:100 * 1024];
    [imageData writeToFile:filePath atomically:YES];
    [XDHTTPRequst uploadFileWithPath:filePath dic:nil name:@"UploadFile" succeed:^(id res) {
        @strongify(self)
        if ([res[@"code"] integerValue] == 200) {
            NSString *faceId = res[@"result"][@"id"];
            NSString *time = res[@"result"][@"createTime"];
            if (!self.roomId) {
                return;
            }
            NSDictionary *dic = @{
                @"faceId":faceId,
                @"unitId":self.unitId
            };
            [XDHTTPRequst updateUserFaceIdWithDic:dic succeed:^(id res) {
                [MBProgressHUD hideHUD];
                if ([res[@"code"] integerValue] == 200) {
                    // 保存本地faceID
                    loginInfo.userModel.faceId = faceId;
                    [XDArchiverManager saveLoginInfo:loginInfo];
                    // 刷新界面UI
                    self.faceImageView.image = image;
                    self.stateLabel.text = @"人脸上传时间";
                    self.timeLabel.text = time;
                    [self.photoBtn setTitle:@"重新上传" forState:(UIControlStateNormal)];
                    // 异步下发人脸到设备
                    [self asyncAccessPermission];
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

// 异步下发权限和人脸
- (void)asyncAccessPermission {
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (!loginInfo.userModel.currentDistrict.projectId || !self.phaseId || !self.userModel.userID || !self.roomId) {
        return;
    }
    NSDictionary *dic = @{
        @"id":self.userModel.userID,
        @"phaseId":self.phaseId,
        @"projectId":loginInfo.userModel.currentDistrict.projectId,
        @"roomId":self.roomId,
        @"type":@"1"
    };
    [XDHTTPRequst accessPermissionWithDic:dic succeed:^(id res) {
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.overlay.photoImageView.image = image;
    self.overlay.photoImageView.hidden = NO;
}

- (void)overlayDidSelect {
    [self uploadFace:self.overlay.photoImageView.image];
}

#pragma mark - lazyLoad
- (NSMutableArray *)permissionArray {
    if (!_permissionArray) {
        _permissionArray = [[NSMutableArray alloc] init];
    }
    return _permissionArray;
}

@end
