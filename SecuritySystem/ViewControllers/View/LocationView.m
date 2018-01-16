//
//  LocationView.m
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/4.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "LocationView.h"

@interface LocationView()
@property (nonatomic, strong) YYLabel *hintLbl;
@property (nonatomic, strong) UIButton *locBtn;
@end

@implementation LocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_RGBA(0x000000, .3);
        [self configView];
    }
    return self;
}
- (void)setHintStr:(NSString *)hintStr{
    _hintStr = hintStr;
    _hintLbl.text = hintStr;
}
- (void)setConfirmStr:(NSString *)confirmStr{
    _confirmStr = confirmStr;
    [_locBtn setTitle:confirmStr forState:UIControlStateNormal];
}

- (void)configView {
    
    UIView *bgView = [UIView new];
    bgView.frame = CGRectMake(0, 0, self.width - 20, 190);
    bgView.backgroundColor = WhiteColor;
    bgView.center = self.center;
    [self addSubview:bgView];
    
    YYLabel *contenLbl = [YYLabel new];
    contenLbl.frame = CGRectMake(0, 40, bgView.width, 55);
    contenLbl.text = @"您的上岗地址还未初始化\n是否要定位到您现在的所在位置？";
    contenLbl.textAlignment = NSTextAlignmentCenter;
    contenLbl.numberOfLines = 0;
    [bgView addSubview:contenLbl];
    self.hintLbl = contenLbl;
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"定位" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, contenLbl.bottom+35, 73, 24);
    btn.centerX = self.centerX - 45 - 73/2;
    btn.backgroundColor = CommonRedColor;
    btn.titleLabel.font = font(15);
    [bgView addSubview:btn];
    self.locBtn = btn;
    self.loactionSignal = [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton new];
    btn2.frame = CGRectMake(0, contenLbl.bottom+35, 73, 24);
    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
    btn2.titleLabel.font = font(15);
    btn2.backgroundColor = CommonRedColor;
    btn2.centerX = self.centerX + 45 + 73/2;
    [bgView addSubview:btn2];
    btn2.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        [self removeFromSuperview];
        return [RACSignal empty];
    }];
    self.cancelSignal = [btn2 rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    ViewBorderRadius(btn, 5, 0, WhiteColor);
    ViewBorderRadius(btn2, 5, 0, WhiteColor);
    ViewBorderRadius(bgView, 5, 0, WhiteColor);
}

@end
