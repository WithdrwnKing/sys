//
//  AttenddanceCollectionViewCell.m
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/26.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "AttenddanceCollectionViewCell.h"

@implementation AttenddanceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.imageView, 0, .5, SEPARATOR_LINE_COLOR);
}

@end
