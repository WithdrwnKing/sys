//
//  WKPicturePreviewVC.h
//  Step
//
//  Created by 王琨 on 2017/12/4.
//  Copyright © 2017年 withdarwn_king. All rights reserved.
//

#import "BaseViewController.h"

@interface WKPicturePreviewVC : BaseViewController
/** 预览的图片或视频数组 */
@property (nonatomic, copy) NSArray *imageList;
/** 点击的图片下标 */
@property (nonatomic, assign) NSInteger selectIndex;
@end
