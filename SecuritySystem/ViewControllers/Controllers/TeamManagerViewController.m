//
//  TeamManagerViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/11.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "TeamManagerViewController.h"
#import "TeamManagerTableViewCell.h"
#import "RegistrationViewController.h"

static NSString *cellIdentifier = @"TeamManagerTableViewCell";
@interface TeamManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, copy) NSArray *membersArray;
@end

@implementation TeamManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"队员管理";
    ViewBorderRadius(_addBtn, 10, 0, WhiteColor);
    [self.tableView registerNib:[UINib nibWithNibName:@"TeamManagerTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    @weakify(self);
    self.addBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        RegistrationViewController *vc = [RegistrationViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        return [RACSignal empty];
    }];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

@end
