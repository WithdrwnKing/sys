//
//  ChosePersonViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/15.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "ChosePersonViewController.h"
#import "AttendanceViewController.h"

#import "ChosePersonTableViewCell.h"

static NSString *cellIdentifier = @"ChosePersonCell";
@interface ChosePersonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIButton *allChoseBtn;
@property (nonatomic, copy) NSArray *modelArray;
@end

@implementation ChosePersonViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择上岗人员";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    [self setUpChoseView];
    [self loadOrgPersonList];
}

- (void)setUpChoseView{
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(SCREEN_WIDTH-40, 24, 30, 30);
    [btn setImage:ImageNamed(@"icon_chose") forState:UIControlStateNormal];
    [btn setImage:ImageNamed(@"ca_right") forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(allChoseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    _allChoseBtn = btn;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.left-100, 0, 90, 30)];
    label.centerY = btn.centerY;
    label.font = font(17);
    label.text = @"全选";
    label.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, label.bottom+3, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [self.view addSubview:line];
    
    [self.view addSubview:self.myTableView];
    
    UIButton *defineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    defineBtn.frame = CGRectMake(24, SCREEN_HEIGHT -STATUSBAR_HEIGHT-44 - 65, (SCREEN_WIDTH - 48 - 35)/2, 35);
    defineBtn.backgroundColor = [UIColor redColor];
    [defineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [defineBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [defineBtn addTarget:self action:@selector(buttonClcked:) forControlEvents:UIControlEventTouchUpInside];
    defineBtn.tag = 100;
    [self.view addSubview:defineBtn];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleBtn.frame = CGRectMake(defineBtn.right+35, defineBtn.top, defineBtn.width, defineBtn.height);
    cancleBtn.backgroundColor = [UIColor redColor];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(buttonClcked:) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.tag = 200;
    [self.view addSubview:cancleBtn];
    
    ViewBorderRadius(defineBtn, 5, 0, WhiteColor);
    ViewBorderRadius(cancleBtn, 5, 0, WhiteColor);

}
#pragma mark - 网络
- (void)loadOrgPersonList {
    WeaklySelf(weakSelf);
    [[SMGApiClient sharedClient] getOrgDetailWithOrgId:_orgId andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            weakSelf.modelArray = [NSArray modelArrayWithClass:[ChosePersonModel class] json:aResponse];
            [weakSelf.myTableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChosePersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ChosePersonModel *model = self.modelArray[indexPath.row];
    model.position = self.orgName;
    [cell updateCellWithModel:model];
    return cell;
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.f;
}
#pragma mark - Actions
- (void)allChoseBtnClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    for (ChosePersonModel *model in self.modelArray) {
        model.isSelected = sender.selected;
    }
    [self.myTableView reloadData];
}
- (void)buttonClcked:(UIButton *)sender{
    switch (sender.tag) {
        case 100:{
            BOOL isPush = NO;
            NSMutableArray *selectArr = [NSMutableArray array];
            for (ChosePersonModel *model in self.modelArray) {
                if (model.isSelected == YES) {
                    isPush = YES;
                    [selectArr addObject:model];
                }
            }
            if (isPush) {
                AttendanceViewController *vc = [AttendanceViewController new];
                vc.selectArray = selectArr.copy;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [ToastUtils showAtTop:@"请选择上岗人员"];
                
            }
            break;
        }
        case 200:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - lazy loading
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-44-60-95)];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerNib:[UINib nibWithNibName:@"ChosePersonTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        _myTableView.tableFooterView = [UIView new];
    }
    return _myTableView;
}
@end
