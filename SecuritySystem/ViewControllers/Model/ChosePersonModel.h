//
//  ChosePersonModel.h
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChosePersonModel : NSObject
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, assign) BOOL isSelected;
@end
