//
//  WKPicturePreviewVC.m
//  Step
//
//  Created by 王琨 on 2017/12/4.
//  Copyright © 2017年 withdarwn_king. All rights reserved.
//

#import "WKPicturePreviewVC.h"
#import "PhotoCell.h"
static NSString * const phtotCellIdentifier = @"identifier";

@interface WKPicturePreviewVC ()<UICollectionViewDelegate, UICollectionViewDataSource, PhotoCellDelegate>

@end

@implementation WKPicturePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建UICollectionView
    [self createCollectionView];
}
#pragma mark - 创建UICollectionView

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    [self.view addSubview:collectionView];
    
    // 显示点击的那张图片
    collectionView.contentOffset = CGPointMake(SCREEN_WIDTH * self.selectIndex, 0);
    
    // 注册cell
    [collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:phtotCellIdentifier];
}


#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:phtotCellIdentifier forIndexPath:indexPath];
    cell.model = self.imageList[indexPath.item];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *photoCell = (PhotoCell *)cell;
    [photoCell showCellAnimation];
}


- (void)hiddenPhotoBrowserWithPhotoCell:(PhotoCell *)photoCell
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
