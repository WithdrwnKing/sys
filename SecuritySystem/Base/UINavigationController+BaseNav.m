//
//  UINavigationController+BaseNav.m
//  Step
//
//  Created by 王琨 on 2017/10/18.
//  Copyright © 2017年 withdarwn_king. All rights reserved.
//

#import "UINavigationController+BaseNav.h"
#import "BaseNavController.h"

@implementation UINavigationController (BaseNav)

- (void)setRootViewController:(UIViewController *)rootViewController{
    if (!rootViewController) {
        return;
    }
    if (![self isKindOfClass:[BaseNavController class]]) {
        return;
    }
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.viewControllers];
    [vcs removeAllObjects];
    [vcs addObject:rootViewController];
    [self setViewControllers:vcs animated:YES];
    NSLog(@"%@",vcs);
}

- (UIViewController *)rootViewController{
    return [self.viewControllers firstObject];
}
@end
