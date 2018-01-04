//
//  WKLocationManager.m
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/4.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "WKLocationManager.h"
@interface WKLocationManager()
@end

@implementation WKLocationManager
SingletonM(WKLocationManager);
- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
    }
    return _locationManager;
}

@end
