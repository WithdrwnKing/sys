//
//  ChosePersonTableViewCell.h
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChosePersonModel.h"

@interface ChosePersonTableViewCell : UITableViewCell
@property (nonatomic, strong) ChosePersonModel *model;
- (void)updateCellWithModel:(ChosePersonModel *)model;
@end
