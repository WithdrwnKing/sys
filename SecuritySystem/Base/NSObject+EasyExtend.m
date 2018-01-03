//
//  NSObject+EasyExtend.m
//  ChargingPile_ios
//
//  Created by withdarwn_king on 2017/3/23.
//  Copyright © 2017年 withdarwn_king. All rights reserved.
//

#import "NSObject+EasyExtend.h"

@implementation NSObject (EasyExtend)
-(BOOL)isNotEmpty{
    return !(self == nil
             || [self isKindOfClass:[NSNull class]]
             || ([self respondsToSelector:@selector(length)]
                 && [(NSData *)self length] == 0)
             || ([self respondsToSelector:@selector(count)]
                 && [(NSArray *)self count] == 0));
    
}

- (NSString *)asNSString
{
    if ( [self isKindOfClass:[NSNull class]] )
        return nil;
    
    if ( [self isKindOfClass:[NSString class]] )
    {
        return (NSString *)self;
    }
    else if ( [self isKindOfClass:[NSData class]] )
    {
        NSData * data = (NSData *)self;
        
        NSString * text = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
        if ( nil == text )
        {
            text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ( nil == text )
            {
                text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            }
        }
        return text;
    }
    else
    {
        return [NSString stringWithFormat:@"%@", self];	
    }
}

@end
