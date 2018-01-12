//
//  UIImage+EasyExtend.m
//  SecuritySystem
//
//  Created by 慧子 on 2018/1/12.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "UIImage+EasyExtend.h"

@implementation UIImage (EasyExtend)
- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
@end
