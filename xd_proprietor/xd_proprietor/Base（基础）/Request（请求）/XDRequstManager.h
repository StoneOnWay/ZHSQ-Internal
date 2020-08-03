//
//  Created by cfsc on 2020/2/5.
//  Copyright © 2020年 cfsc. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^ success) (id resp);
typedef void(^ failure) (NSError *errors);

@interface XDRequstManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)POST:(NSString *)path parameters:(id)parameters succend:(success)succeed fail:(failure)fail;

- (void)POST:(NSString *)path jsonParameters:(id)parameters succend:(success)succeed fail:(failure)fail;

- (void)PUT:(NSString *)path parameters:(id)parameters succend:(success)succeed fail:(failure)fail;

- (void)PUT:(NSString *)path jsonParameters:(id)parameters succend:(success)succeed fail:(failure)fail;

- (void)DELETE:(NSString *)path parameters:(id)parameters succend:(success)succeed fail:(failure)fail;

- (void)GET:(NSString *)path parameters:(id)parameters succend:(success)succeed fail:(failure)fail;

- (void)POST:(NSString *)path parameters:(id)parameters name:(NSString *)name constructingBodyWithFilePath:(NSString *)filePath succend:(success)succeed fail:(failure)fail;

- (void)POST:(NSString *)path jsonParameters:(id)parameters name:(NSString *)name constructingBodyWithBlock:(NSArray *)imageDatas succend:(success)succeed fail:(failure)fail;

- (void)POST:(NSString *)path parameters:(id)parameters name:(NSString *)name constructingBodyWithBlock:(NSArray *)imageDatas succend:(success)succeed fail:(failure)fail;

- (void)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas succend:(success)succeed fail:(failure)fail;

@end
