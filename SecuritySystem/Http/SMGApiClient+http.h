//
//  SMGApiClient+http.h
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/28.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "SMGApiClient.h"

@interface SMGApiClient (http)

/**
 @brief 登录

 @param account 账号
 @param password 密码
 */
- (NSURLSessionDataTask *)loginWithAccount:(NSString *)account password:(NSString *)password andCompletion:(ApiCompletion)completion;

/**
 @brief 获取用户所在大队信息

 @param userId 用户id
 */
- (NSURLSessionDataTask *)getOrgWithUserId:(NSString *)userId andCompletion:(ApiCompletion)completion;

/**
 @brief 获取用户所在大队信息
 
 @param orgId 大队id
 */
- (NSURLSessionDataTask *)getOrgDetailWithOrgId:(NSString *)orgId andCompletion:(ApiCompletion)completion;
/**
 @brief 搜索训练大队
 
 @param orgName 搜索文字
 */
- (NSURLSessionDataTask *)searchOrgWithName:(NSString *)orgName andCompletion:(ApiCompletion)completion;

@end
