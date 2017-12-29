//
//  UserInfoModel.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/28.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "UserInfoModel.h"
#import <NSObject+YYModel.h>

@implementation UserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"orgId":@"ID",@"orgName":@"Name",@"orgAddress":@"Address"};
}

- (id)copyWithZone:(NSZone *)zone{
    return [self modelCopy];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
@end
