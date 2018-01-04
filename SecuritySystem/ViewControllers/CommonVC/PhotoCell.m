//
//  PhotoCell.m
//  SHReporter
//
//  Created by 沈树亮 on 17/5/3.
//  Copyright © 2017年 CDV. All rights reserved.
//

#import "PhotoCell.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>

@interface PhotoCell() <UIScrollViewDelegate>

// 预览图片
@property (nonatomic, strong) UIImageView *photoImageView;
// UIScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
// 视频播放器
@property (strong, nonatomic) AVPlayer *player;
@end

@implementation PhotoCell


#pragma mark - 初始化

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.frame = self.bounds;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView addSubview:self.photoImageView];
    }
    return _scrollView;
}

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.frame = self.bounds;
        _photoImageView.userInteractionEnabled = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // 图片单击
        UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick:)];
        gesture1.numberOfTapsRequired = 1;
        [_photoImageView addGestureRecognizer:gesture1];
        
        // 图片双击
        UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
        gesture2.numberOfTapsRequired = 2;
        [_photoImageView addGestureRecognizer:gesture2];
        [gesture1 requireGestureRecognizerToFail:gesture2];
    }
    return _photoImageView;
}

- (AVPlayer *)player
{
    if (!_player) {
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.model];
        _player = [AVPlayer playerWithPlayerItem:item];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.contentView.layer addSublayer:layer];
    }
    return _player;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 添加scrollView
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}


#pragma mark - 图片点击事件

// 单击事件
- (void)singleClick:(UITapGestureRecognizer *)gesture
{
    // 退出浏览页面
    if ([self.delegate respondsToSelector:@selector(hiddenPhotoBrowserWithPhotoCell:)]) {
        [self.delegate hiddenPhotoBrowserWithPhotoCell:self];
    }
}

// 双击事件
- (void)doubleClick:(UITapGestureRecognizer *)gesture
{
    // 还原图片
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.zoomScale = 1.0;
    }];
}


#pragma mark - setter

- (void)setModel:(id )model
{
    _model = model;
    
    // 视频
    if ([model isKindOfClass:[NSURL class]]) {
        [self.player play];
        return;
    }
//    if ([model.fileType isEqualToString:@"video"]) {
//        [self.player play];
//        return;
//    }
    
    // 图片
//    if ([model.fileType isEqualToString:@"picture"]) {
        // 显示图片
    if ([model isKindOfClass:[UIImage class]]) {
        self.photoImageView.image = model;
        return;
    }
//    }
    
    // 声音
}


#pragma mark - <UIScrollViewDelegate>

// 图片缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImageView;
}

// 图片居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.photoImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

// 动画显示cell
- (void)showCellAnimation
{
    self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}
@end
