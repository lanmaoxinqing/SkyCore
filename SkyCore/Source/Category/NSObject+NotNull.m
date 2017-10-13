//
//  NSObject+NotNull.m
//  hostel-iphone
//
//  Created by liu ding on 12-7-12.
//  Copyright 2012年 teemax. All rights reserved.
//

#import "NSObject+NotNull.h"


@implementation NSObject(NotNull)

-(BOOL)isNotNull{
    if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null]){
        return YES;
    }
    return NO;
}

-(BOOL)isNotEmpty{
    if([self isKindOfClass:[NSArray class]] ||
       [self isKindOfClass:[NSMutableArray class]] ||
       [self isKindOfClass:[NSSet class]] ||
       [self isKindOfClass:[NSMutableSet class]] ||
       [self isKindOfClass:[NSDictionary class]] ||
       [self isKindOfClass:[NSMutableDictionary class]]){
        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(count)] && [self performSelector:@selector(count) withObject:nil]>0){
            return YES;
        }
        return NO;
    }
//    if([self isKindOfClass:[NSSet class]] ||
//       [self isKindOfClass:[NSMutableSet class]]){
//        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(count)] && [(NSSet *)self count]>0){
//            return YES;
//        }
//        return NO;
//    }
//    if([self isKindOfClass:[NSDictionary class]] ||
//       [self isKindOfClass:[NSMutableDictionary class]]){
//        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(count)] && [(NSDictionary *)self count]>0){
//            return YES;
//        }
//        return NO;
//    }
    if([self isKindOfClass:[NSString class]]){
        if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null] && [self respondsToSelector:@selector(length)] && [(NSString *)self length]>0){
            return YES;
        }
        return NO;
    }
    if(self!=nil && self!=NULL && (NSNull *)self!=[NSNull null]){
        return YES;
    }
    return NO;
}

@end
