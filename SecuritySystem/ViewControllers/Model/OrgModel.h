//
//  OrgModel.h
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/28.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrgModel : NSObject
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, assign) BOOL isSelected;
@end
