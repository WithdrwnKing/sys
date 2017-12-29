//
//  TrainingCollectionViewCell.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/19.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "TrainingCollectionViewCell.h"

@implementation TrainingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self bringSubviewToFront:self.deleteBtn];
}

@end
