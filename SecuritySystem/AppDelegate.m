//
//  AppDelegate.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/14.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BaseNavController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AppDelegate+baiduFace.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setUpSVProgressHUDCustom];
    [self netWorkReachability];
    [self startBaiduFace];
    
    [AMapServices sharedServices].apiKey = @"8854cb55e62cacaa107634d7dfc4fc0b";

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:[LoginViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark - custom
- (void)setUpSVProgressHUDCustom{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMaximumDismissTimeInterval:1.5f];
    [SVProgressHUD setMinimumDismissTimeInterval:.5f];
}
//开启网络监控
-(void)netWorkReachability {
    
    //开启网络状况的监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:{
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"_isInLine"];
                NSLog(@"无网络网络");
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"_isInLine"];
                NSLog(@"2G、3G/4G网络");
                break;
            }
            case AFNetworkReachabilityStatusUnknown:{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"_isInLine"];
                
                NSLog(@"未识别网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"wifi网络");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"_isInLine"];
                
                break;
            }
            default:
                break;
        }
        
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
