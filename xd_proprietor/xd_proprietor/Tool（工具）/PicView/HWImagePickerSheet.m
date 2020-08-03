//
//  HWImagePickerSheet.m
//  PhotoSelector
//
//  Created by hw on 2017/1/12.
//  Copyright © 2017年 hw. All rights reserved.
//

#import "HWImagePickerSheet.h"
#import "BaseNavigationController.h"


@interface HWImagePickerSheet ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation HWImagePickerSheet
-(instancetype)init{
    self = [super init];
    if (self) {
        if (!_arrSelected) {
            self.arrSelected = [NSMutableArray array];
        }
    }
    return self;
}

// 显示选择照片提示Sheet
- (void)showImgPickerActionSheetInView:(UIViewController *)controller popoverView:(UIView *)popoverView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
    if ([XDUtil isIPad]) {
        UIPopoverPresentationController *popoverVC = [alertController popoverPresentationController];
        popoverVC.sourceView = popoverView;
        popoverVC.sourceRect = popoverView.bounds;
    }
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍照"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL isAllow = [[KyIsOpenPrivate sharedManager] isAllowPrivacyCamera];
        if (!isAllow) {
            return;
        }
        if (!imaPic) {
            imaPic = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;
            imaPic.delegate = self;
            [self.viewController presentViewController:imaPic animated:NO completion:nil];
        }
        
    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"相册"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL isAllow = [[KyIsOpenPrivate sharedManager] isAllowPrivacyLibrary];
        if (!isAllow) {
            return;
        }
        [self loadImgDataAndShowAllGroup];
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionCamera];
    [alertController addAction:actionAlbum];
    self.viewController = controller;
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 加载照片数据
- (void)loadImgDataAndShowAllGroup{
    if (!_arrSelected) {
        self.arrSelected = [NSMutableArray array];
    }
    __weak typeof(self) weakSelf = self;
    [[MImaLibTool shareMImaLibTool] getAllGroupWithArrObj:^(NSArray *arrObj) {
        if (arrObj && arrObj.count > 0) {
            self.arrGroup = arrObj;
            if ( self.arrGroup.count > 0) {
                MShowAllGroup *svc = [[MShowAllGroup alloc] initWithArrGroup:self.arrGroup arrSelected:self.arrSelected];
                svc.delegate = self;
                BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:svc];
                if (_arrSelected) {
                    svc.arrSeleted = _arrSelected;
                    svc.mvc.arrSelected = _arrSelected;
                }
                svc.maxCout = 1;
                [weakSelf.viewController presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}
#pragma mark - 拍照获得数据
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    __weak typeof(self) weakSelf = self;
    UIImage *theImage = nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (theImage) {
        //保存图片到相册中
        MImaLibTool *imgLibTool = [MImaLibTool shareMImaLibTool];
        [imgLibTool.lib writeImageToSavedPhotosAlbum:[theImage CGImage] orientation:(ALAssetOrientation)[theImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
            } else {
                
                //获取图片路径
                [imgLibTool.lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        if (!weakSelf.arrSelected) {
                            weakSelf.arrSelected = [NSMutableArray array];
                        }
                        [weakSelf.arrSelected addObject:asset];
                        [weakSelf finishSelectImg];
                        [picker dismissViewControllerAnimated:NO completion:nil];
                    } else {
                        if (!weakSelf.arrSelected) {
                            weakSelf.arrSelected = [NSMutableArray array];
                        }
                        [weakSelf.arrSelected addObject:theImage];
                        [weakSelf finishSelectImg];
                        [picker dismissViewControllerAnimated:NO completion:nil];
                        
                    }
                } failureBlock:^(NSError *error) {
                    
                }];
            }
        }];
    }
    
}
#pragma mark - 完成选择后返回的图片Array(ALAsset*)
- (void)finishSelectImg {
    // 正方形缩略图
    NSMutableArray *thumbnailImgArr = [NSMutableArray array];
    
    for (int i = 0; i < self.arrSelected.count; i++) {
        if (![self.arrSelected.firstObject isKindOfClass:[UIImage class]]) {
            ALAsset *set = self.arrSelected[i];
            CGImageRef cgImg = [set aspectRatioThumbnail];
            UIImage* image = [UIImage imageWithCGImage: cgImg];
            [thumbnailImgArr addObject:image];
            
        }else {
            UIImage *image = self.arrSelected[i];
            image = [self thumbnailWithImage:image size:CGSizeMake(kScreenWidth, kScreenHeight)];
            [thumbnailImgArr addObject:image];
        }
        
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectImageWithALAssetArray:thumbnailImageArray:)]) {
        [self.delegate getSelectImageWithALAssetArray:_arrSelected thumbnailImageArray:thumbnailImgArr];
    }
}

- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    } else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end
