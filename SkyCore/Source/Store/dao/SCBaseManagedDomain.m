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
    NSString *className = NSStringFromClass(self.class);
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

-(void)sync:(NSManagedObject *)obj{
    if(![obj isKindOfClass:[self class]]){
        NSAssert(NO, @"复制的对象类型不一致");
    }
    [self yy_modelSetWithJSON:[obj yy_modelToJSONObject]];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self yy_modelEncodeWithCoder:aCoder];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    return [self yy_modelInitWithCoder:aDecoder];
}

@end
