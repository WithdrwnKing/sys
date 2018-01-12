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

- (NSURLSessionDataTask *)getStaffInfoWithStaffID:(NSString *)StaffID andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:StaffID forKey:@"StaffID"];
    return [self postPath:@"GetStaffInfo.ashx" parameters:dict completion:completion];
}
- (NSURLSessionDataTask *)submitOrgAddr:(NSString *)orgID userID:(NSString *)userID address:(NSString *)address longitude:(NSString *)longitude dimension:(NSString *)dimension andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:orgID forKey:@"OrgID"];
    [dict setObject:address forKey:@"Address"];
    [dict setObject:userID forKey:@"userID"];
    [dict setObject:longitude forKey:@"Longitude"];
    [dict setObject:dimension forKey:@"Dimension"];
    [dict setObject:CURRENTUSER.infoModel.CustomerID forKey:@"customerID"];

    return [self postPath:@"SubmitOrgAddr.ashx" parameters:dict completion:completion];
}
- (NSURLSessionDataTask *)submitStaffInfo:(NSString *)StaffID orgID:(NSString *)OrgID Name:(NSString *)Name Tel:(NSString *)Tel Number:(NSString *)Number ContrastImage:(NSString *)ContrastImage userID:(NSString *)userId andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:OrgID forKey:@"OrgID"];
    [dict setObject:StaffID forKey:@"StaffID"];
    [dict setObject:Name forKey:@"Name"];
    [dict setObject:Tel forKey:@"Tel"];
    [dict setObject:Number forKey:@"Number"];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:ContrastImage forKey:@"ContrastImage"];
    return [self postPath:@"SubmitStaffInfo.ashx" parameters:dict completion:completion];
}

- (NSURLSessionDataTask *)faceRecognitionWithStaffID:(NSString *)StaffID fileData:(NSData *)fileData andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:StaffID forKey:@"StaffID"];
    return [self postPath:@"FaceRecognition.ashx" withImage:fileData parameters:dict completion:completion];
}

- (NSURLSessionDataTask *)submitCheckingWithOrgID:(NSString *)OrgID Address:(NSString *)Address Type:(NSString *)Type Remark:(NSString *)Remark StaffID:(NSString *)StaffID ContrastImage:(NSString *)ContrastImage Status:(NSString *)Status andCompletion:(ApiCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:OrgID forKey:@"OrgID"];
    [dict setObject:Address forKey:@"Address"];
    [dict setObject:StaffID forKey:@"StaffID"];
    [dict setObject:Type forKey:@"Type"];
    [dict setObject:Remark forKey:@"Remark"];
    [dict setObject:ContrastImage forKey:@"ContrastImage"];
    [dict setObject:Status forKey:@"Status"];
    [dict setObject:CURRENTUSER.userId forKey:@"userID"];

    return [self postPath:@"SubmitChecking.ashx" parameters:dict completion:completion];
}

- (NSURLSessionDataTask *)staffFaceCollectWithStaffID:(NSString *)StaffID Filedata:(UIImage *)Filedata FiledataContrast:(UIImage *)FiledataContrast andCompletion:(ApiCompletion)completion{
    
    NSData *imagedata1 = UIImagePNGRepresentation(Filedata);
    NSData *imagedata2 = UIImagePNGRepresentation(FiledataContrast);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (![StaffID isNotEmpty]) {
        StaffID = @"0";
    }
    [dict setObject:StaffID forKey:@"StaffID"];
    
    NSURLSessionDataTask *task = [self POST:@"StaffFaceCollect.ashx" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imagedata1 name:@"Filedata" fileName:@"image.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:imagedata2 name:@"FiledataContrast" fileName:@"image2.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            if([responseObject[@"code"] integerValue]==1){
                id body = [responseObject objectForKey:@"data"];
                completion(task, body, nil);
                
            }else{
                if(responseObject){
                    NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:[responseObject[@"code"] intValue] userInfo:@{@"message":responseObject[@"message"]}];
                    completion(task,nil,error);
                    
                }else{
                    NSError *error = [[NSError alloc] initWithDomain:SERVER_URL code:-1 userInfo:@{@"message":@"服务器内部错误"}];
                    completion(task,nil,error);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            NSError *anError = [[NSError alloc] initWithDomain:SERVER_URL code:error.code userInfo:error.userInfo];
            completion(task, nil, anError);
        }
    }];
    return task;
}
@end
