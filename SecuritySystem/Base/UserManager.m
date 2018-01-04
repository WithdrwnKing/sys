//
//  UserManager.m
//  ChargingPile_ios
//
//  Created by withdarwn_king on 2017/3/27.
//  Copyright © 2017年 withdarwn_king. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager
static UserManager *_sharedUser = nil;

+(UserManager *)currentUser{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUser = [[UserManager alloc] init];
    });
    
    return _sharedUser;
}

-(id)init{
    self = [super init];
    if(self){
        if([NSKeyedUnarchiver unarchiveObjectWithFile:[UserManager userSavePath]]){
            self = [NSKeyedUnarchiver unarchiveObjectWithFile:[UserManager userSavePath]];
        }
        
        //        [self getUserInfoWithCompletion:nil];
        [self performSelector:@selector(_refreshUserInfo) withObject:nil afterDelay:0.01];
    }
    
    return self;
}
- (void)_refreshUserInfo
{
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _token = [aDecoder decodeObjectForKey:@"token"];
        _city = [aDecoder decodeObjectForKey:@"city"];
        _headImg = [aDecoder decodeObjectForKey:@"headImg"];
        _nickName = [aDecoder decodeObjectForKey:@"nickName"];
        _userId = [aDecoder decodeObjectForKey:@"userId"];
        _gender = [aDecoder decodeObjectForKey:@"gender"];
        _type = [aDecoder decodeObjectForKey:@"type"];
        _infoModel = [aDecoder decodeObjectForKey:@"UserInfoModel"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_headImg forKey:@"headImg"];
    [aCoder encodeObject:_nickName forKey:@"nickName"];
    [aCoder encodeObject:_gender forKey:@"gender"];
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_infoModel forKey:@"UserInfoModel"];
}
-(BOOL)isLogin{
    return _token.length>0&&_userId.length>0;
}
-(void)configUserWithDic:(NSDictionary *)dic{
    
    for(NSString *key in [dic allKeys]){
        //第三方的信息如果后台数据没有，就采用第三方的头像和用户名
        if([key isEqualToString:@"nickName"] || [key isEqualToString:@"avator"]){
            NSString *value = dic[key];
            if(value && value.length > 0){
                [self setValue:dic[key] forKey:key];
            }
        }else{
            if([dic[key] isKindOfClass:[NSDictionary class]]){
                [self configDicValue:dic[key] withKey:key];
            }else if ([dic[key] isKindOfClass:[NSArray class]]){
                [self configArrayValue:dic[key] withKey:key];
            }else{
                [self setValue:dic[key] forKey:key];
            }
        }
    }
    [self saveUser];
}

//解析数组型数据
-(void)configArrayValue:(id)obj withKey:(NSString *)key{
    NSString *className = [NSString stringWithFormat:@"%@",key];
    Class clazz = NSClassFromString(className);
    if(!clazz){
        NSLog(@"model %@ %@ class undeclare",NSStringFromClass([self class]),key);
    }else{
        NSMutableArray *arrayObj = [NSMutableArray new];
        for(NSDictionary *dic in obj){
            if([dic isKindOfClass:[NSString class]]){
                [arrayObj addObject:dic];
            }else if([dic isKindOfClass:[NSDictionary class]]){
                id item = [[clazz alloc] initWithDictionary:dic];
                [arrayObj addObject:item];
            }
        }
        [self setValue:arrayObj forKeyPath:key];
    }
}

-(void)configDicValue:(id)obj withKey:(NSString *)key{
    Class clazz = NSClassFromString(key);
    if(clazz){
        id myObj = [[clazz alloc] initWithDictionary:obj];
        [self setValue:myObj forKeyPath:key];
    }else{
        NSLog(@"%@ class undeclare",key);
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"class key %@ not exist",key);
}


+(NSString *)userSavePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"user.archive"];
}

-(void)saveUser{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:self toFile:[UserManager userSavePath]];
    });
}

- (void)logout{
    [self clearData];
    [self saveUser];
    
}
- (void)clearData{
    _token = nil;
    _userId = nil;
    _city = nil;
    _headImg = nil;
    _nickName = nil;
    _gender = nil;
    _infoModel = nil;
}
@end
