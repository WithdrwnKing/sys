//
//  WKFileService.h
//  Step
//
//  Created by 王琨 on 2018/1/12.
//  Copyright © 2018年 withdarwn_king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKFileService : NSObject
//缓存文件大小
+(float)folderSizeAtPath:(NSString *)path;
+(void)clearCache:(NSString *)path;

@end
