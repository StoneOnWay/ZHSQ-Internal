//
//  HWImagePickerSheet.h
//  PhotoSelector
//
//  Created by hw on 2017/1/12.
//  Copyright © 2017年 hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MImaLibTool.h"
#import "MShowAllGroup.h"

typedef enum {
    selectSend = 1,
    selectedCancel = 2,
    selectedCamera = 3,
    selectPhotoLib = 4
}menuSelectedType;
/**
 *  定义选择的block方法
 */
typedef void (^menuSelectBlock)(id obj, menuSelectedType type);
/**
 *  代理协议
 */
@protocol HWImagePickerSheetDelegate <NSObject>

@optional
/**
 *  相册完成选择得到图片
 */
-(void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray;

@end
@interface HWImagePickerSheet : NSObject<UIImagePickerControllerDelegate,UIActionSheetDelegate,MShowAllGroupDelegate>{
    UIImagePickerController *imaPic;
    
}

/**
 *  代理协议
 */
@property (nonatomic, assign) id<HWImagePickerSheetDelegate> delegate;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *arrTitles;
@property (nonatomic, copy)   menuSelectBlock menuBlock;
@property (nonatomic, strong) NSArray *arrGroup;
@property (nonatomic, strong) NSMutableArray *arrSelected;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, weak) UIViewController *viewController;
/**
 *  显示选择照片提示sheet
 */
- (void)showImgPickerActionSheetInView:(UIViewController *)controller popoverView:(UIView *)popoverView;

@end
