//
//  BaseNavController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/15.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "BaseNavController.h"

@interface BaseNavController ()

@end

@implementation BaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.hidden = YES;
    [self.navigationBar setTranslucent:NO];
    self.navigationBar.barTintColor = [UIColor redColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Arial-Bold" size:17.5], NSFontAttributeName,nil]];
    //去掉背景图片
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    UIViewController *vc = self.topViewController;
    return [vc preferredStatusBarStyle];
}
@end
