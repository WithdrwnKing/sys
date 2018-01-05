//
//  MainViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/15.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "MainViewController.h"
#import "ChosePersonViewController.h"
#import "UploadTrainingViewController.h"
#import "ChosePositionViewController.h"
#import "UserInfoModel.h"
#import "LoginViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UILabel *orgNameLbl;
@property (nonatomic, strong) UIButton *orgAddressBtn;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, copy) NSString *posString;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMainView];
    self.view.backgroundColor = RGB(245, 246, 247);
    [self loadMainData];
}
//对导航栏隐藏的设置，避免子页面缺失
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)setUpMainView{
    
    [self.view addSubview:self.myScrollView];
    CGFloat headViewHeight = 150 + STATUSBAR_HEIGHT;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headViewHeight)];
    headView.backgroundColor = [UIColor redColor];
    
    UIImageView *logoImv = [[UIImageView alloc] initWithFrame:CGRectMake(16, STATUSBAR_HEIGHT+10, 52, 64)];
    logoImv.image = ImageNamed(@"ca_hlogo");
    [headView addSubview:logoImv];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(logoImv.right+13, logoImv.top+10, SCREEN_WIDTH-logoImv.right-13-60, 20)];
    nameLbl.font = font(17.5);
    nameLbl.textColor = WhiteColor;
    nameLbl.text = @"上海南方大厦保安大队";
    [headView addSubview:nameLbl];
    _orgNameLbl = nameLbl;
    
    UIImageView *iconImv = [[UIImageView alloc] initWithImage:ImageNamed(@"ca_hcaptain")];
    iconImv.frame = CGRectMake(nameLbl.left, nameLbl.bottom+12, iconImv.image.size.width, iconImv.image.size.height);
    [headView addSubview:iconImv];
    
    UILabel *positionLbl = [UILabel new];
    positionLbl.frame = CGRectMake(iconImv.right+5, iconImv.top, nameLbl.width-iconImv.width-5, iconImv.height);
    positionLbl.textColor = HEX_RGB(0xffda71);
    positionLbl.font = font(15);
    positionLbl.text = @"队长：李秀莲";
    [headView addSubview:positionLbl];
    self.nameLbl = positionLbl;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, logoImv.bottom+33, SCREEN_WIDTH, .5)];
    line.backgroundColor = WhiteColor;
    [headView addSubview:line];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16, line.bottom, SCREEN_WIDTH-16, headViewHeight-line.bottom)];
    btn.enabled = NO;
    [btn setImage:ImageNamed(@"ca_haddress") forState:UIControlStateNormal];
    [btn setTitle:@"上海市闵行区古方路18号南方大厦" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btn.titleLabel setFont:font(12.5)];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headView addSubview:btn];
    self.orgAddressBtn = btn;
    
    UIButton *infoBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-135/2, 56, 135/2, 22)];
    [infoBtn setBackgroundImage:ImageNamed(@"ca_hback") forState:UIControlStateNormal];
    [infoBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [infoBtn setTitle:@"注销登录" forState:UIControlStateNormal];
    [infoBtn.titleLabel setFont:font(10)];
    infoBtn.tag = 1024;
    [infoBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:infoBtn];
    
    [_myScrollView addSubview:headView];

    NSArray *titleArray = @[@"上岗考勤",@"训练上传",@"队员管理",@"考勤记录",@"训练记录",@"客户信息"];
    NSArray *imageArray = @[ImageNamed(@"ca_btn01"),ImageNamed(@"ca_btn02"),ImageNamed(@"ca_btn03"),ImageNamed(@"ca_btn04"),ImageNamed(@"ca_btn05"),ImageNamed(@"ca_btn06")];
    CGFloat width = (SCREEN_WIDTH-30-50)/3;
    for (int i = 0; i<6; i++) {
        UIButton *btn = [UIButton new];
        btn.tag = 100+i;
        btn.frame = CGRectMake(15 + i%3*(width+25), headView.bottom + 50 + i/3*(width+55) , width, width);
        [btn setImage:imageArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = WhiteColor;
        [_myScrollView addSubview:btn];
        ViewBorderRadius(btn, width/2, 1, BlackColor);
        
        UILabel *title = [UILabel new];
        title.frame = CGRectMake(btn.left, btn.bottom, btn.width, 35);
        title.text = titleArray[i];
        title.font = font(13);
        title.textAlignment = NSTextAlignmentCenter;
        [_myScrollView addSubview:title];
        if (i == 5) {
            _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, title.bottom);
        }
    }
}
#pragma mark - AFN
- (void)loadMainData {
    WeaklySelf(weakSelf);
    [[SMGApiClient sharedClient] getOrgWithUserId:CURRENTUSER.userId andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            NSLog(@"%@",aResponse);
            CURRENTUSER.infoModel = [UserInfoModel modelWithJSON:aResponse];
            [CURRENTUSER saveUser];
            [weakSelf refreshView];
        }
    }];
    [[SMGApiClient sharedClient] dictWithCategoryID:@"2" andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            NSArray *listArr = (NSArray *)aResponse;
            for (NSDictionary *dict in listArr) {
                NSString *type = [dict objectForKey:@"ID"];
                if ([CURRENTUSER.type integerValue] == [type integerValue]) {
                    weakSelf.posString = [dict objectForKey:@"Name"];
                    [weakSelf refreshView];
                    break;
                }
            }
        }
    }];
}

- (void)refreshView{
    [self.orgAddressBtn setTitle:CURRENTUSER.infoModel.orgAddress forState:UIControlStateNormal];
    self.orgNameLbl.text = CURRENTUSER.infoModel.orgName;
    self.nameLbl.text = [NSString stringWithFormat:@"%@：%@",self.posString,CURRENTUSER.nickName];
}

#pragma mark - Actions
- (void)btnClicked:(UIButton *)sender{
    switch (sender.tag) {
        case 100:{
            ChosePersonViewController *vc = [ChosePersonViewController new];
            vc.orgId = CURRENTUSER.infoModel.orgId;
            vc.orgName = CURRENTUSER.infoModel.orgName;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 101:{
            ChosePositionViewController *vc = [ChosePositionViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 102:{
            
            break;
        }
        case 103:{
           
            break;
        }
        case 104:{
            
            break;
        }
        case 105:{
            
            break;
        }
        case 1024:{
            [CURRENTUSER logout];
            self.navigationController.rootViewController = [LoginViewController new];
            break;
        }
        default:
            break;
    }
}

#pragma mark - lazy loading
- (UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _myScrollView;
}

@end
