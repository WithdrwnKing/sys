//
//  ChosePositionViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "ChosePositionViewController.h"
#import "ChosePositionCell.h"

@interface ChosePositionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *seachTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, copy) NSArray *orgList;
@end

@implementation ChosePositionViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择训练大队";
    ViewBorderRadius(_searchBtn, 5, 0, WhiteColor);
    ViewBorderRadius(_seachTextField, 0, .5, SEPARATOR_LINE_COLOR);
    ViewBorderRadius(_commitBtn, 5, 0, WhiteColor);
    ViewBorderRadius(_cancelBtn, 5, 0, WhiteColor);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChosePositionCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - 网络
- (void)searchOrgList {
    WeaklySelf(weakSelf);
    [[SMGApiClient sharedClient] searchOrgWithName:_seachTextField.text andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            weakSelf.orgList = [NSArray modelArrayWithClass:[OrgModel class] json:aResponse];
            [weakSelf.tableView reloadData];
        }
    }];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length>0) {
        [textField resignFirstResponder];
        [self searchOrgList];
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orgList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChosePositionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    OrgModel *model = self.orgList[indexPath.row];
    [cell updateCellWithModel:model];
    return cell;
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.f;
}
#pragma mark - actions
- (IBAction)choseAllOrg:(UIButton *)sender {
    sender.selected = !sender.selected;
    for (OrgModel *model in self.orgList) {
        model.isSelected = sender.selected;
    }
    [self.tableView reloadData];
}
- (IBAction)seachBtnClicked:(UIButton *)sender {
    [_seachTextField resignFirstResponder];
    if (_seachTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"搜索内容不能为空"];
        return;
    }
    [self searchOrgList];
}
- (IBAction)cancelBtnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)commitBtnClicked:(UIButton *)sender {
}
@end
