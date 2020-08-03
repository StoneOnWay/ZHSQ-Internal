//
//  Created by cfsc on 2020/7/13.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDServerDataManager.h"
#import <UIKit/UIKit.h>
#import "XDServerConfigCellModel.h"
#import "XDHomeMenuModel.h"

static XDServerDataManager *data = nil;
@implementation XDServerDataManager

+ (XDServerDataManager *)shareDataManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[XDServerDataManager alloc] init];
        data.isEditing = NO;
    });
    return data;
}

- (void)setUpData:(id)data {
    self.data = data;
    [self.dataArray removeAllObjects];
    [self.headArray removeAllObjects];
    [self.titleArray removeAllObjects];
    [self.homeMenuArray removeAllObjects];
    NSArray *array = data;
    for (NSDictionary *dic in array) {
        NSString *title = dic[@"title"] ? dic[@"title"] : @"";
        NSString *type = dic[@"programType"];
        NSArray *programs = dic[@"data"];
        NSMutableArray *temp = [NSMutableArray array];
        if ([type isEqualToString:@"MY_APPS"]) {
            // 我的应用放在第一个
            [self.titleArray insertObject:title atIndex:0];
            for (NSDictionary *dic in programs) {
                XDServerConfigCellModel *model = [XDServerConfigCellModel mj_objectWithKeyValues:dic];
                model.state = ServeSelected;
                model.isNewAdd = NO;
                model.backGroundColor = RGB(246, 246, 246);
                [temp addObject:model];
            }
            [self.dataArray insertObject:temp atIndex:0];
            self.headArray = temp;
        } else {
            [self.titleArray addObject:title];
            for (NSDictionary *dic in programs) {
                XDServerConfigCellModel *model = [XDServerConfigCellModel mj_objectWithKeyValues:dic];
                model.state = ServeAdd;
                model.isNewAdd = NO;
                model.backGroundColor = RGB(246, 246, 246);
                [temp addObject:model];
            }
            [self.dataArray addObject:temp];
        }
    }
    // 将全部应用里面已选择的状态改为select
    for (int i = 1; i < self.dataArray.count; i++) {
        NSArray *array = self.dataArray[i];
        for (XDServerConfigCellModel *model in array) {
            if ([self isMyProgram:model]) {
                model.state = ServeSelected;
            }
        }
    }
    if (self.headArray.count == 0) {
        self.isShowHeaderMessage = YES;
    } else {
        for (XDServerConfigCellModel *model in [XDServerDataManager shareDataManager].headArray) {
            XDHomeMenuModel *menu = [[XDHomeMenuModel alloc] init];
            menu.title = model.name;
            menu.iconUrl = model.iconUrl;
            if ([model.type isEqualToString:@"EXTERNAL"]) {
                menu.vcType = XDVCTypeJxbWeb;
                menu.jxbUrl = model.routeAddress;
            } else if ([model.type isEqualToString:@"INTERNAL"]) {
                menu.viewControllerStr = [self addressChange:model.routeAddress];
            }
            [self.homeMenuArray addObject:menu];
        }
        if ((self.homeMenuArray.count % 4) != 0) {
            NSInteger emptyCount = 4 - (self.homeMenuArray.count % 4);
            for (int i = 0; i < emptyCount; i++) {
                XDHomeMenuModel *empty = [[XDHomeMenuModel alloc] init];
                [self.homeMenuArray addObject:empty];
            }
        }
    }
}

- (NSString *)addressChange:(NSString *)address {
    NSDictionary *dic = @{
        @"workProgress" : @"XDInformNewsListController",
        @"join" : @"XDInformNewsListController",
        @"notices" : @"XDInformNewsListController",
        @"payment" : @"XDLiveChargeController",
        @"complaint" : @"XDFlowCreateController",
        @"workOrder" : @"XDFlowCreateController"
    };
    return dic[address];
}

// 是否是不可以使用的应用
- (BOOL)isUnusableProgram:(NSString *)title {
    NSArray *invalidArr = @[@"门禁开锁", @"访客邀约", @"可视对讲", @"智能锁车", @"投诉建议", @"报事报修", @"生活缴费", @"我的报修", @"我的投诉", @"车辆管理"];
    return [invalidArr containsObject:title];
}

- (BOOL)isMyProgram:(XDServerConfigCellModel *)cellModel {
    for (XDServerConfigCellModel *model in self.headArray) {
        if ([model.programId isEqualToString:cellModel.programId]) {
            return YES;
        }
    }
    return NO;
}

- (void)recoverData {
    [self setUpData:self.data];
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (NSMutableArray *)headArray {
    if (!_headArray) {
        _headArray = [[NSMutableArray alloc] init];
    }
    return _headArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)homeMenuArray {
    if (!_homeMenuArray) {
        _homeMenuArray = [[NSMutableArray alloc] init];
    }
    return _homeMenuArray;
}


@end
