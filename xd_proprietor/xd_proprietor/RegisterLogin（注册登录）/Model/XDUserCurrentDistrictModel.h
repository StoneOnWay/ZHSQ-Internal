//
//  Created by cfsc on 2020/3/13.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDUserCurrentDistrictModel : NSObject <NSCoding>
// projectId
@property (nonatomic, copy) NSString *projectId;
// 项目名称
@property (nonatomic, copy) NSString *projectName;
// phaseId
@property (nonatomic, copy) NSString *phaseId;
// buildingId
@property (nonatomic, copy) NSString *buildingId;
// unitId
@property (nonatomic, copy) NSString *unitId;
// roomId
@property (nonatomic, copy) NSString *roomId;
// roomName
@property (nonatomic, copy) NSString *roomName;
// phaseName
@property (nonatomic, copy) NSString *phaseName;
// unitName
@property (nonatomic, copy) NSString *unitName;
// buildingName
@property (nonatomic, copy) NSString *buildingName;
// 是否入伙
@property (nonatomic, copy) NSString *joinStatus;
@end

NS_ASSUME_NONNULL_END
