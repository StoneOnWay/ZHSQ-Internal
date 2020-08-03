//
//  Created by cfsc on 2020/2/5.
//  Copyright © 2020年 cfsc. All rights reserved.
//

#import "XDRequstManager.h"

#define BaseURL [NSURL URLWithString:@"http://baidu.com/"]

@implementation XDRequstManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static XDRequstManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [self manager];
        manager.requestSerializer.timeoutInterval = 18.0f;
        //数据类型解析失败，这个错误工作中经常见到
        //设置更多的数据类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript" ,@"text/html", nil];
        // 设置请求头
        [manager.requestSerializer setValue:@"webApp" forHTTPHeaderField:@"client_id"];
        [manager.requestSerializer setValue:@"webApp" forHTTPHeaderField:@"client_secret"];
    });
    return manager;
}

- (void)POST:(NSString *)path parameters:(id)parameters succend:(success)succeed fail:(failure)fail {
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self setRequestHeader];
    [self POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

- (void)POST:(NSString *)path jsonParameters:(id)parameters succend:(success)succeed fail:(failure)fail {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self setRequestHeader];
    [self POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

- (void)PUT:(NSString *)path parameters:(id)parameters succend:(success)succeed fail:(failure)fail {
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self setRequestHeader];
    [self PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

- (void)PUT:(NSString *)path jsonParameters:(id)parameters succend:(success)succeed fail:(failure)fail {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self setRequestHeader];
    [self PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

- (void)DELETE:(NSString *)path parameters:(id)parameters succend:(success)succeed fail:(failure)fail {
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self setRequestHeader];
    [self DELETE:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

// 设置请求头
- (void)setRequestHeader {
    [self.requestSerializer setValue:@"mobile" forHTTPHeaderField:@"client_id"];
    [self.requestSerializer setValue:@"mobile" forHTTPHeaderField:@"client_secret"];
    XDLoginInfoModel *loginInfo = [XDArchiverManager loginInfo];
    if (loginInfo) {
        NSString *authStr = [NSString stringWithFormat:@"%@ %@", loginInfo.tokenModel.token_type, loginInfo.tokenModel.access_token];
        [self.requestSerializer setValue:authStr forHTTPHeaderField:@"Authorization"];
    }
}

- (void)GET:(NSString *)path parameters:(id)parameters succend:(success)succeed fail:(failure)fail {
    [self setRequestHeader];
    [self GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

- (void)POST:(NSString *)path parameters:(id)parameters name:(NSString *)name constructingBodyWithFilePath:(NSString *)filePath succend:(success)succeed fail:(failure)fail {
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self setRequestHeader];
    [self POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传的参数(上传图片，以文件的格式)
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

- (void)POST:(NSString *)path parameters:(id)parameters name:(NSString *)name constructingBodyWithBlock:(NSArray *)imageDatas succend:(success)succeed fail:(failure)fail {
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self setRequestHeader];
    [self POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传的参数(上传图片，以文件流的格式)
        if (imageDatas.count != 0) {
            for (int i = 0; i < imageDatas.count; i++) {
                NSData *data = [imageDatas objectAtIndex:i];
                [formData appendPartWithFileData:data name:name fileName:[NSString stringWithFormat:@"image%ld.png",(long)i]  mimeType:@"image/png"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

- (void)POST:(NSString *)path jsonParameters:(id)parameters name:(NSString *)name constructingBodyWithBlock:(NSArray *)imageDatas succend:(success)succeed fail:(failure)fail {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self setRequestHeader];
    [self POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传的参数(上传图片，以文件流的格式)
        if (imageDatas.count != 0) {
            for (int i = 0; i < imageDatas.count; i++) {
                NSData *data = [imageDatas objectAtIndex:i];
                [formData appendPartWithFileData:data name:name fileName:[NSString stringWithFormat:@"image%ld.png",(long)i]  mimeType:@"image/png"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

- (void)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas succend:(success)succeed fail:(failure)fail {
    [self POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传的参数(上传图片，以文件流的格式)
        if (imageDatas.count != 0) {
            for (int i = 0; i < imageDatas.count; i++) {
                NSData *data = [imageDatas objectAtIndex:i];
                [formData appendPartWithFileData:data name:@"pic" fileName:[NSString stringWithFormat:@"image%ld.png",(long)i]  mimeType:@"image/png"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
    
}

@end
