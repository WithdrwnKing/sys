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


/**
 @brief 获取队员个人信息

 @param StaffID 队员id
 */
- (NSURLSessionDataTask *)getStaffInfoWithStaffID:(NSString *)StaffID andCompletion:(ApiCompletion)completion;

/**
 @brief 初始化定位地址上传
 */
- (NSURLSessionDataTask *)submitOrgAddr:(NSString *)orgID userID:(NSString *)userID address:(NSString *)address longitude:(NSString *)longitude dimension:(NSString *)dimension andCompletion:(ApiCompletion)completion;


/**
 @brief 新增队员或老员工信息上传接口
 */
- (NSURLSessionDataTask *)submitStaffInfo:(NSString *)StaffID orgID:(NSString *)OrgID Name:(NSString *)Name Tel:(NSString *)Tel Number:(NSString *)Number ContrastImage:(NSString *)ContrastImage userID:(NSString *)userId andCompletion:(ApiCompletion)completion;

/**
 @brief 脸部图片的采集
 */
- (NSURLSessionDataTask *)staffFaceCollectWithStaffID:(NSString *)StaffID Filedata:(UIImage *)Filedata FiledataContrast:(UIImage *)FiledataContrast andCompletion:(ApiCompletion)completion;

/**
 @brief 考勤人脸识别
 */
- (NSURLSessionDataTask *)faceRecognitionWithStaffID:(NSString *)StaffID fileData:(NSData *)fileData andCompletion:(ApiCompletion)completion;

/**
 @brief 上传考勤信息
 */
- (NSURLSessionDataTask *)submitCheckingWithOrgID:(NSString *)OrgID Address:(NSString *)Address Type:(NSString *)Type Remark:(NSString *)Remark StaffID:(NSString *)StaffID ContrastImage:(NSString *)ContrastImage Status:(NSString *)Status andCompletion:(ApiCompletion)completion;


/**
 @brief 获取考勤类型
 */
- (NSURLSessionDataTask *)getTypeOfWorkAndCompletion:(ApiCompletion)completion;

/**
 @brief 上传回访客户拍的照片
 */
- (NSURLSessionDataTask *)uploadClientImgWithImageData:(NSData *)fileData andCompletion:(ApiCompletion)completion;

/**
 @brief 上传客户回访信息
 */
- (NSURLSessionDataTask *)subClientReviewTheme:(NSString *)theme imageUrl:(NSString *)imageUrl andCompletion:(ApiCompletion)completion;
@end
