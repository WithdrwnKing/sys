//
//  PhotoCell.h
//  SHReporter
//
//  Created by 沈树亮 on 17/5/3.
//  Copyright © 2017年 CDV. All rights reserved.
//  

#import <UIKit/UIKit.h>
@class PhotoCell;

@protocol PhotoCellDelegate <NSObject>

@required
/**
 单击图片退出预览
 */
- (void)hiddenPhotoBrowserWithPhotoCell:(PhotoCell *)photoCell;
@end


@interface PhotoCell : UICollectionViewCell

@property (nonatomic, weak) id<PhotoCellDelegate> delegate;

/** 素材模型 */
@property (nonatomic, strong) id model;

/**
 动画显示cell
 */
- (void)showCellAnimation;
@end
