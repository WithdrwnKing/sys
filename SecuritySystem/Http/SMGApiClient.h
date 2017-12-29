//
//  SMGApiClient.h
//  SHReporter
//
//  Created by withdarwn_king on 16/8/22.
//  Copyright © 2016年 CDV. All rights reserved.
//

#import <AFNetworking.h>

//正式URL
//#define SERVER_URL  @"http://api.showki.wang/"

//测试URL
#define SERVER_URL  @"http://203.156.205.228:8008/Handler/Interface/"

typedef void(^ApiCompletion)(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError* anError);
typedef void (^UploadProgress)(long long sent, long long expectSend);

@interface SMGApiClient : AFHTTPSessionManager

+(id)sharedClient;

/**
 *
 *  基本post方法
 *
 *  @param aPath       路径
 *  @param parameters  参数
 *  @param aCompletion 回调
 *
 */
-(NSURLSessionDataTask *)postPath:(NSString *)aPath parameters:(NSDictionary *)parameters completion:(ApiCompletion)aCompletion;

/**
 *
 *  基本get方法
 *
 *  @param aPath      路径
 *  @param parameters 参数
 *  @param completion 完成的回调
 *
 *
 */
-(NSURLSessionDataTask *)getPath:(NSString *)aPath parameters:(NSDictionary *)parameters completion:(ApiCompletion)completion;

/**
 @brief 带图片的post方法

 @param aPath       路径
 @param imageData   图片
 @param parameters  参数
 @param aCompletion 完成回调

 */
-(NSURLSessionDataTask *)postPath:(NSString *)aPath withImage:(NSData *)imageData  parameters:(NSDictionary *)parameters completion:(ApiCompletion)aCompletion;


@end
