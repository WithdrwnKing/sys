//
//  UserManager.h
//  ChargingPile_ios
//
//  Created by withdarwn_king on 2017/3/27.
//  Copyright © 2017年 withdarwn_king. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

#define CURRENTUSER  [UserManager currentUser]
@interface UserManager : NSObject

//个人信息
/** 用户id */
@property(nonatomic, strong) NSString *userId;
/** 头像地址 */
@property(nonatomic, strong) NSString *headImg;
/** 昵称 */
@property(nonatomic, strong) NSString *nickName;
/** 性别 */
@property(nonatomic, strong) NSString *gender;
/** 城市 */
@property(nonatomic, strong) NSString *city;
/** token */
@property(nonatomic, strong) NSString *token;
/** 身份类型 */
@property(nonatomic, strong) NSString *type;
/** 所属大队id */
@property(nonatomic, strong) UserInfoModel *infoModel;
//仅供判断是否登录用
@property (nonatomic,readonly) BOOL isLogin;

+(UserManager *)currentUser;

-(void)saveUser;

-(void)configUserWithDic:(NSDictionary *)dic;

//退出登录
-(void)logout;

@end
