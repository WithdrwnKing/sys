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
 @brief 字典接口
 
 @param categoryID 账号
 */
- (NSURLSessionDataTask *)dictWithCategoryID:(NSString *)categoryID andCompletion:(ApiCompletion)completion;
/**
 @brief 获取用户所在大队信息

 @param userId 用户id
 */
- (NSURLSessionDataTask *)getOrgWithUserId:(NSString *)userId andCompletion:(ApiCompletion)completion;

/**
 @brief 获取用户所在大队队员信息
 
 @param orgId 大队id
 */
- (NSURLSessionDataTask *)getOrgDetailWithOrgId:(NSString *)orgId andCompletion:(ApiCompletion)completion;
/**
 @brief 搜索训练大队

 @param orgName 搜索文字
 */
- (NSURLSessionDataTask *)searchOrgWithName:(NSString *)orgName andCompletion:(ApiCompletion)completion;

/**
 @brief 上传训练信息

 @param theme 训练主题
 @param address 定位地址
 @param remark 训练说明
 @param orgId 大队id
 @param classId 图片类型id
 @param SimagesUrl 缩略图
 @param ImagesUrl 原图片
 @param VideoUrl 视频
 */
- (NSURLSessionDataTask *)uploadTrainInfoWithTheme:(NSString *)theme address:(NSString *)address remark:(NSString *)remark orgId:(NSString *)orgId classId:(NSString *)classId SimagesUrl:(NSString *)SimagesUrl ImagesUrl:(NSString *)ImagesUrl VideoUrl:(NSString *)VideoUrl andCompletion:(ApiCompletion)completion;
@end
