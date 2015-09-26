//
//  NSObject+Persistence.m
//  SkyCore
//
//  Created by sky on 14/12/5.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "NSObject+Persistence.h"

@implementation NSObject(Persistence)

-(void)enumPropertiesUsingBlock:(void (^)(NSString *propertyName,NSUInteger idx,BOOL *stop))block{
    [[self class] enumPropertiesUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        block(propertyName,idx,stop);
    }];
}

+(void)enumPropertiesUsingBlock:(void (^)(NSString *, NSUInteger, BOOL *))block{
    unsigned int outCount=0;
    BOOL stop=NO;
    objc_property_t * const properties=class_copyPropertyList([self class], &outCount);
    if(outCount>0){
        for(int i=0;i<outCount;i++){
            if(stop){
                break;
            }
            NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
            block(propertyName,i,&stop);
        }
    }
    free(properties);
}

@end
