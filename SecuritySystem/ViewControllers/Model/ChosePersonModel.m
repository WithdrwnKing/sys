//
//  ChosePersonModel.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "ChosePersonModel.h"

@implementation ChosePersonModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"userId":@"ID",@"nickName":@"Name",@"headImgUrl":@"ImageUrl",@"tel":@"Tel"};
}
- (id)copyWithZone:(NSZone *)zone{
    return [self modelCopy];
}
@end
