//
//  TeamManagerTableViewCell.h
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/11.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChosePersonModel.h"

@interface TeamManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImv;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *telLbl;

- (void)updateCellWithModel:(ChosePersonModel *)model;

@end
