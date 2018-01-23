//
//  AppDelegate+baiduFace.m
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/23.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#define FACE_LICENSE_ID         @"CACheck-face-ios"
// 人脸license文件名
#define FACE_LICENSE_NAME    @"idl-license"

// 人脸license后缀
#define FACE_LICENSE_SUFFIX  @"face-ios"

#import "AppDelegate+baiduFace.h"
#import "IDLFaceSDK/IDLFaceSDK.h"

@implementation AppDelegate (baiduFace)

- (void)startBaiduFace{
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
}
@end
