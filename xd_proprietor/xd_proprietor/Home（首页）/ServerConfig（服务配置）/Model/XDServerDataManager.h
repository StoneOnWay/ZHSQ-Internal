//
//  Created by cfsc on 2020/7/13.
//  Copyright © 2020 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XDServerConfigCellModel;
@interface XDServerDataManager : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSMutableArray *homeMenuArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
// 是否显示无我的应用
@property (nonatomic, assign) BOOL isShowHeaderMessage;
// 是否正在编辑
@property (nonatomic, assign) BOOL isEditing;

+ (XDServerDataManager *)shareDataManager;
- (void)setUpData:(id)data;
- (BOOL)isMyProgram:(XDServerConfigCellModel *)cellModel;
// 恢复原始数据
- (void)recoverData;
- (NSString *)addressChange:(NSString *)address;
- (BOOL)isUnusableProgram:(NSString *)title;

@end
