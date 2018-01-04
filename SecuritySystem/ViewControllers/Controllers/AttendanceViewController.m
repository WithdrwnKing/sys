//
//  AttendanceViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/19.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "AttendanceViewController.h"
#import "TrainingCollectionViewCell.h"

@interface AttendanceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selectPhotoBtn;
@property (nonatomic, strong) UIButton *selectTypeBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
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
    
    UILabel *photoLbl = [UILabel new];
    photoLbl.text = @"拍照上传：";
    [self.scrollView addSubview:photoLbl];
    
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TrainingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - lazyLoading
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _scrollView;
}

@end
