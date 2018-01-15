//
//  LoginViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/15.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ViewBorderRadius(_loginBtn, 20, 0, WhiteColor);
    [self setNeedsStatusBarAppearanceUpdate];
    [self setUpTextField];
    
//    if (DEBUG) {
//        _nameTextfield.text = @"admin";
//        _passwordField.text = @"1";
//    }
//    
}

- (void)setUpTextField{
    UIView *leftView = [UIView new];
    leftView.width = 40;
    UIImageView *imv = [[UIImageView alloc] initWithImage:ImageNamed(@"ca_user")];
    imv.center = leftView.center;
    [leftView addSubview:imv];
    _nameTextfield.leftView = leftView;
    _nameTextfield.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView2 = [UIView new];
    leftView2.width = 40;
    UIImageView *imv2 = [[UIImageView alloc] initWithImage:ImageNamed(@"ca_pwd")];
    imv2.center = leftView2.center;
    [leftView2 addSubview:imv2];
    _passwordField.leftView = leftView2;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;

}
- (IBAction)logingBtn:(UIButton *)sender {
    NSLog(@"登录成功");
    if (_nameTextfield.text.length == 0) {
        return;
    }
    if (_passwordField.text.length == 0) {
        return;
    }
    sender.enabled = NO;
    
    [[SMGApiClient sharedClient] loginWithAccount:_nameTextfield.text password:_passwordField.text andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        sender.enabled = YES;
        if (aResponse) {
            [CURRENTUSER setUserId:aResponse[@"ID"]];
            [CURRENTUSER setNickName:aResponse[@"Name"]];
            [CURRENTUSER setType:aResponse[@"Type"]];
            [CURRENTUSER saveUser];
            MainViewController *vc = [MainViewController new];
            self.navigationController.rootViewController = vc;
        }
        if (anError) {
            [SVProgressHUD showErrorWithStatus:anError.userInfo[@"message"]];
        }
    }];

}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
