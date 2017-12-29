//
//  AttendanceViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/19.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "AttendanceViewController.h"

@interface AttendanceViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selectPhotoBtn;
@property (nonatomic, strong) UIButton *selectTypeBtn;

@end

@implementation AttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传员工考勤信息";
    [self setUpUI];
}
- (void)setUpUI{
    UILabel *typeLbl = [UILabel new];
    typeLbl.text = @"上岗类型：";
    [self.scrollView addSubview:typeLbl];
    
    UIButton *selectTypeBtn = [UIButton new];
    [self.scrollView addSubview:selectTypeBtn];
    
}

#pragma mark - lazyLoading
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _scrollView;
}

@end
