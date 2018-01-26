//
//  DetectionViewController.h
//  IDLFaceSDKDemoOC
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "FaceBaseViewController.h"

typedef void(^PersonImage)(UIImage *);

@interface DetectionViewController : FaceBaseViewController

@property (nonatomic, strong) PersonImage imageBlock;

@end
