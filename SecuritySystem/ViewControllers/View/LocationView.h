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
@property (nonatomic, strong) RACSignal *cancelSignal;

@property (nonatomic, copy) NSString *hintStr;
@property (nonatomic, copy) NSString *confirmStr;

@end
