//
//  ChosePositionViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "ChosePositionViewController.h"
#import "ChosePositionCell.h"
#import "UploadTrainingViewController.h"

@interface ChosePositionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *seachTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
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
    ViewBorderRadius(_seachTextField, 5, .5, SEPARATOR_LINE_COLOR);
    ViewBorderRadius(_commitBtn, 5, 0, WhiteColor);
    ViewBorderRadius(_cancelBtn, 5, 0, WhiteColor);
        
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChosePositionCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self searchOrgList];
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
    self.allSelectBtn.selected = NO;
    [_seachTextField resignFirstResponder];
    [self searchOrgList];
}
- (IBAction)cancelBtnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)commitBtnClicked:(UIButton *)sender {
    [self.seachTextField resignFirstResponder];
    BOOL isPush = NO;
    NSMutableArray *orgArr = [NSMutableArray array];
    for (OrgModel *model in self.orgList) {
        if (model.isSelected == YES) {
            isPush = YES;
            [orgArr addObject:model.orgId];
        }
    }
    if (isPush) {
        UploadTrainingViewController *vc = [UploadTrainingViewController new];
        vc.orgIdStr = [orgArr componentsJoinedByString:@","];
        [self.navigationController pushViewController:vc animated:YES];
    }else
        ShowToastAtTop(@"请选择要上传训练视频的大队");        
}
@end
