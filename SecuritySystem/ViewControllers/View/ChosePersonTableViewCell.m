//
//  ChosePersonTableViewCell.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "ChosePersonTableViewCell.h"

@interface ChosePersonTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImv;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *positionLbl;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@end

@implementation ChosePersonTableViewCell

- (void)updateCellWithModel:(ChosePersonModel *)model{
    _model = model;
    self.selectBtn.selected = model.isSelected;
    [self.headImv setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholder:ImageNamed(@"icon_head")];
    self.nameLbl.text = model.nickName;
    self.positionLbl.text = model.position;
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
