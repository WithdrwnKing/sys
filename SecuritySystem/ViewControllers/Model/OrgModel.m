//
//  OrgModel.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/28.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "OrgModel.h"

@implementation OrgModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"orgId":@"ID",@"orgName":@"Name"};
}
@end
