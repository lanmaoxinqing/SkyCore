//
//  BaseManagedDomain.m
//  coreDataTest
//
//  Created by liud on 13-5-27.
//  Copyright (c) 2013年 liud. All rights reserved.
//

#import "SCBaseManagedDomain.h"
#import "SCBaseDao.h"
#import <objc/runtime.h>

@implementation SCBaseManagedDomain

-(id)init{
    NSString *className=[NSString stringWithUTF8String:class_getName([self class])];
    self=[NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[SCBaseDao tempContext]];//涉及到一个临时上下文
    if(self!=nil){
        return self;
    }
    return nil;
}

-(id)initPersistence{
    NSString *className=[NSString stringWithUTF8String:class_getName([self class])];
    self=[NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[SCBaseDao context]];
    if(self!=nil){
        return self;
    }
    return nil;
}

-(void)valueFrom:(NSManagedObject *)obj{
    if(![obj isKindOfClass:[self class]]){
        NSAssert(NO, @"复制的对象类型不一致");
    }else{
        NSDictionary *attributes = self.entity.attributesByName;
        for (NSString *attr in attributes) {
            [self setValue:[obj valueForKey:attr] forKey:attr];
        }
    }
}

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

//-(id)initWithElement:(GDataXMLElement *)ele{
//    //    NSAssert(NO, @"子类请重写[BaseDomain initWithDictionary:]方法");
//    //    return nil;
//    if(self=[super init]){
//        [self enumPropertiesUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
//            //首字母大写
//            NSString *firstLetter=[propertyName substringToIndex:1];
//            NSString *modifyName=[propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstLetter uppercaseString]];
//            id value=[[ele elementsForName:modifyName][0] stringValue];
//            if(value){
//                [self setValue:value forKey:propertyName];
//                return ;
//            }
//            //使用原字段设置
//            value=[[ele elementsForName:propertyName][0] stringValue];
//            if(value){
//                [self setValue:value forKey:propertyName];
//            }
//        }];
//        return self;
//    }
//    return nil;
//}

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
    return (self);
}

@end
