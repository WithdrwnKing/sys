//
//  ChosePositionCell.h
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgModel.h"

@interface ChosePositionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, strong) OrgModel *model;

- (void)updateCellWithModel:(OrgModel *)model;

@end
