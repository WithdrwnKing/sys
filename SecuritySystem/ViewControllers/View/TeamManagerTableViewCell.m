//
//  TeamManagerTableViewCell.m
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/11.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "TeamManagerTableViewCell.h"

@implementation TeamManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithModel:(ChosePersonModel *)model{
    [_headImv setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholder:ImageNamed(@"icon_head")];
    _nameLbl.text = [NSString stringWithFormat:@"姓名：%@",model.nickName];
    _telLbl.text = [NSString stringWithFormat:@"电话：%@",model.tel];
}

@end
