//
//  ChosePositionCell.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "ChosePositionCell.h"

@implementation ChosePositionCell
- (void)updateCellWithModel:(OrgModel *)model{
    _model = model;
    self.selectBtn.selected = model.isSelected;
    self.nameLbl.text = model.orgName;
}
- (IBAction)cellSelected:(UIButton *)sender {
    sender.selected = !sender.selected;
    _model.isSelected = sender.selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
