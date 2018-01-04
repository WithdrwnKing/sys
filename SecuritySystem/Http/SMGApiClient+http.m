//
//  SMGApiClient+http.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/28.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "SMGApiClient+http.h"

@implementation SMGApiClient (http)
- (NSURLSessionDataTask *)loginWithAccount:(NSString *)account password:(NSString *)password andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:account forKey:@"UserCD"];
    [dict setObject:password forKey:@"PassWord"];
    
    return [self getPath:@"Login.ashx" parameters:dict completion:completion];
}
- (NSURLSessionDataTask *)dictWithCategoryID:(NSString *)categoryID andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:categoryID forKey:@"categoryID"];
    return [self getPath:@"GetItemsByCategory.ashx" parameters:dict completion:completion];

}
- (NSURLSessionDataTask *)getOrgWithUserId:(NSString *)userId andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userId forKey:@"userID"];
    return [self getPath:@"GetOrg.ashx" parameters:dict completion:completion];
}
- (NSURLSessionDataTask *)getOrgDetailWithOrgId:(NSString *)orgId andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:orgId forKey:@"OrgID"];
    return [self getPath:@"GetStaffBYOrg.ashx" parameters:dict completion:completion];
}
- (NSURLSessionDataTask *)searchOrgWithName:(NSString *)orgName andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:orgName forKey:@"OrgName"];
    return [self getPath:@"GetOrgsByName.ashx" parameters:dict completion:completion];
}
- (NSURLSessionDataTask *)uploadTrainInfoWithTheme:(NSString *)theme address:(NSString *)address remark:(NSString *)remark orgId:(NSString *)orgId classId:(NSString *)classId SimagesUrl:(NSString *)SimagesUrl ImagesUrl:(NSString *)ImagesUrl VideoUrl:(NSString *)VideoUrl andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:CURRENTUSER.userId forKey:@"userID"];
    [dict setObject:theme forKey:@"Theme"];
    [dict setObject:address forKey:@"Address"];
    [dict setObject:remark forKey:@"Remark"];
    [dict setObject:orgId forKey:@"OrgID"];
    [dict setObject:classId forKey:@"ClassID"];
    if (ImagesUrl) {
        [dict setObject:ImagesUrl forKey:@"ImagesUrl"];
    }
    if (SimagesUrl) {
        [dict setObject:SimagesUrl forKey:@"SimagesUrl"];
    }
    if (VideoUrl) {
        [dict setObject:VideoUrl forKey:@"VideoUrl"];
    }
    return [self postPath:@"SubTrainInfo.ashx" parameters:dict completion:completion];
}
@end
