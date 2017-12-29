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
@end
