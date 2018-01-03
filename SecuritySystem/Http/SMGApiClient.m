//
//  SMGApiClient.m
//  SHReporter
//
//  Created by withdarwn_king on 16/8/22.
//  Copyright © 2016年 CDV. All rights reserved.
//

#import "SMGApiClient.h"

static SMGApiClient *_sharedClient = nil;

@implementation SMGApiClient

+(id)sharedClient{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SMGApiClient alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //不发送json数据
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        //响应json数据
        _sharedClient.responseSerializer  = [AFJSONResponseSerializer serializer];
        
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",@"application/x-www-form-urlencoded",@"image/jpeg", nil];
    });
    
    return _sharedClient;
}

/*
 基本post方法
 */
-(NSURLSessionDataTask *)postPath:(NSString *)aPath parameters:(NSDictionary *)parameters completion:(ApiCompletion)aCompletion {
    
//    NSLog(@"请求post地址:%@%@ 参数:%@",SERVER_URL,aPath,parameters);
//    NSMutableString *_str = [NSMutableString stringWithFormat:@"%@%@?",SERVER_URL,aPath];
//    for (int i = 0; i<parameters.allKeys.count; i++) {
//        NSString *key = [parameters.allKeys objectAtIndex:i];
//        [_str appendString:[NSString stringWithFormat:@"%@=%@&",key,[parameters objectForKey:key]]];
//    }
//    [_str deleteCharactersInRange:NSMakeRange(_str.length-1, 1)];
//    NSLog(@"%@",_str);
    NSURLSessionDataTask *task = [self POST:aPath parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (aCompletion) {
          
            if([responseObject[@"code"] integerValue] == 1){
                id body = [responseObject objectForKey:@"data"];
               
                aCompletion(task, body, nil);
            }else{
                if(responseObject){
                    NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:[responseObject[@"code"] intValue] userInfo:@{@"text":responseObject[@"message"]}];
                    aCompletion(task,nil,error);
                    
                }else{
                    NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:-1 userInfo:@{@"text":@"服务器内部错误"}];
                    aCompletion(task,nil,error);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (aCompletion) {
            NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:-1 userInfo:@{@"text":@"服务器内部错误"}];
            aCompletion(task, nil, error);
        }
    }];
    return task;
}
/**
 *  @author Henry
 *
 *  基本get方法
 *
 *  @param aPath      路径
 *  @param parameters 参数
 *  @param completion 完成回调
 *
 */
-(NSURLSessionDataTask *)getPath:(NSString *)aPath parameters:(NSDictionary *)parameters completion:(ApiCompletion)completion{
    NSLog(@"请求get地址:%@ 参数:%@",aPath,parameters);
    
    NSURLSessionDataTask *task = [self GET:aPath parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(completion){
            if([responseObject[@"code"] intValue] == 1){
                id body = [responseObject objectForKey:@"data"];
                completion(task,body,nil);
            }else{
                if(responseObject){
                    NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:[responseObject[@"code"] intValue] userInfo:@{@"message":[responseObject objectForKey:@"message"]}];
                    completion(task,nil,error);
                }else{
                    NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:-1 userInfo:@{@"text":@"服务器内部错误"}];
                    completion(task,nil,error);
                }
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completion)
            completion(task,nil,error);
    }];
    
    return task;
}

- (NSURLSessionDataTask *)postPath:(NSString *)aPath withImage:(NSData *)imageData parameters:(NSDictionary *)parameters completion:(ApiCompletion)aCompletion{
    
    NSURLSessionDataTask *task = [self POST:aPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"Filedata" fileName:@"image.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (aCompletion) {
            
            if([responseObject[@"code"] integerValue]==1){
                id body = [responseObject objectForKey:@"data"];
                aCompletion(task, body, nil);
                
            }else{
                if(responseObject){
                    NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:[responseObject[@"code"] intValue] userInfo:@{@"text":responseObject[@"message"]}];
                    aCompletion(task,nil,error);
                    
                }else{
                    NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:-1 userInfo:@{@"text":@"服务器内部错误"}];
                    aCompletion(task,nil,error);
                }
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (aCompletion) {
            NSError *anError = [[NSError alloc] initWithDomain:SERVER_URL code:error.code userInfo:error.userInfo];
            aCompletion(task, nil, anError);
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)postPath:(NSString *)aPath withVideo:(NSData *)videoData parameters:(NSDictionary *)parameters completion:(ApiCompletion)aCompletion{
    
    NSURLSessionDataTask *task = [self POST:aPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:videoData name:@"Filedata" fileName:@"video.mp4" mimeType:@"video/mp4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (aCompletion) {
            
            if([responseObject[@"code"] integerValue]==1){
                id body = [responseObject objectForKey:@"data"];
                aCompletion(task, body, nil);
                
            }else{
                if(responseObject){
                    NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:[responseObject[@"code"] intValue] userInfo:@{@"text":responseObject[@"message"]}];
                    aCompletion(task,nil,error);
                    
                }else{
                    NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:-1 userInfo:@{@"text":@"服务器内部错误"}];
                    aCompletion(task,nil,error);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (aCompletion) {
            NSError *anError = [[NSError alloc] initWithDomain:SERVER_URL code:error.code userInfo:error.userInfo];
            aCompletion(task, nil, anError);
        }
    }];
    return task;
}

@end
