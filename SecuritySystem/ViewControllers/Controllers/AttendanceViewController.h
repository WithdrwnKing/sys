//
//  AttendanceViewController.h
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/19.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "BaseViewController.h"
@class ChosePersonModel;
@interface AttendanceViewController : BaseViewController
@property (nonatomic, copy) NSArray <ChosePersonModel *>*selectArray;
@end
