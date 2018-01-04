//
//  LocationView.h
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/4.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationView : UIView
@property (nonatomic, strong) RACSignal *loactionSignal;
@end
