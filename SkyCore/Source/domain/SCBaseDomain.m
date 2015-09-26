//
//  BaseDomain.m
//  SkyCore
//
//  Created by sky on 14-3-18.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "SCBaseDomain.h"
#import <objc/runtime.h>
#import "GDataXMLNode.h"

@implementation SCBaseDomain

-(id)initWithDictionary:(NSDictionary *)dic{
//    NSAssert(NO, @"子类请重写[BaseDomain initWithDictionary:]方法");
//    return nil;
    if(self=[super init]){
        [self enumPropertiesUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
            id value=[dic objectForKey:propertyName];
            if(value){
                [self setValue:value forKey:propertyName];
            }
        }];
        return self;
    }
    return nil;
}

-(id)initWithElement:(GDataXMLElement *)ele{
    //    NSAssert(NO, @"子类请重写[BaseDomain initWithDictionary:]方法");
    //    return nil;
    if(self=[super init]){
        [self enumPropertiesUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
            //首字母大写
            NSString *firstLetter=[propertyName substringToIndex:1];
            NSString *modifyName=[propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstLetter uppercaseString]];
            id value=[[ele elementsForName:modifyName][0] stringValue];
            if(value){
                [self setValue:value forKey:propertyName];
                return ;
            }
            //使用原字段设置
            value=[[ele elementsForName:propertyName][0] stringValue];
            if(value){
                [self setValue:value forKey:propertyName];
            }
        }];
        return self;
    }
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self enumPropertiesUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        id value = [self valueForKey:propertyName];
        if (value == nil)
        {
            value = [NSNull null];
        }
        [aCoder encodeObject:value forKey:propertyName];
    }];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init])
    {
        [self enumPropertiesUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
            [self setValue:[aDecoder decodeObjectForKey:propertyName] forKey:propertyName];
        }];
    }
    return self;
}

@end
