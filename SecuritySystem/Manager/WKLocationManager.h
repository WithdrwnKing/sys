//
//  WKLocationManager.h
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/4.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface WKLocationManager : NSObject
@property (nonatomic, strong) AMapLocationManager *locationManager;
SingletonH(WKLocationManager);
@end
