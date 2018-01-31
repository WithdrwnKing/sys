//
//  OffLineErrorView.m
//  lingzhong
//
//  Created by withdarwn_king on 2017/4/24.
//  Copyright © 2017年 withdarwn_king. All rights reserved.
//

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define FitScreenWidth(W) ((SCREEN_WIDTH/375.f) * W)

#define UIColorFromRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#import "OffLineErrorView.h"
@implementation OffLineErrorView
//懒加载创建imageView
-(UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake((self.frame.size.width-100)/2, 200, FitScreenWidth(279/2),FitScreenWidth(359/2));
        _imageView.image = [UIImage imageNamed:@"offlineerrorpic"];
        _imageView.center = CGPointMake(self.center.x, _imageView.center.y-50);
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self configUI];
    }
    
    return self;
}

- (void)configUI{
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageView];

    [self createlabel1];
    [self createlabel2];
    [self createButton];
    
}

-(void)createlabel1 {
    
    CGFloat imageMaxY = CGRectGetMaxY(self.imageView.frame);
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-150)/2, imageMaxY+10, 150, 20)];
    label1.tag = 101;
    label1.text = @"连接请求失败";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:18];
    [self addSubview:label1];
}

-(void)createlabel2 {
    
    UILabel *label = [self viewWithTag:101];
    CGFloat imageMaxY = CGRectGetMaxY(label.frame);
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-250)/2, imageMaxY+5, 250, 40)];
    label2.tag = 102;
    label2.text = @"请检查您的网络或配置\n重新加载吧";
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor grayColor];
    label2.font = [UIFont systemFontOfSize:15];
    [self addSubview:label2];
}

-(void)createButton {
    
    UILabel *taglabel = [self viewWithTag:102];
    CGFloat imageMaxY = CGRectGetMaxY(taglabel.frame);
    
    UIButton * reLoadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    reLoadButton.frame = CGRectMake((self.frame.size.width-150)/2, imageMaxY+10 + 10, 150, 44);
    [reLoadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [reLoadButton setTintColor:[UIColor grayColor]];
    reLoadButton.titleLabel.font = [UIFont systemFontOfSize:15];
    reLoadButton.backgroundColor = [UIColor clearColor];
    reLoadButton.clipsToBounds = YES;
    reLoadButton.layer.cornerRadius = 2;
    reLoadButton.layer.borderColor = [UIColor grayColor].CGColor;
    reLoadButton.layer.borderWidth = .5;
    [reLoadButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reLoadButton];
}

//重新加载按钮
-(void)buttonClick {
    
    //网络连接正常，webView重新加载数据
    if ([AFNetworkReachabilityManager sharedManager].isReachable == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHWEBVIEW" object:self];
        self.hidden = YES;
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查你的网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}


@end
