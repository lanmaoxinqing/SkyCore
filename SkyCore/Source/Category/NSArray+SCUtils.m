//
//  NSArray+MZ.m
//  meizhuang
//
//  Created by Ricky on 16/6/29.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "NSArray+SCUtils.h"

@implementation NSArray (SCIterator)

- (NSArray *)sc_map:(id (^)(id))block
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        id mapObj = block(obj);
        if (mapObj) {
            [arr addObject:mapObj];
        }
    }];
    return [NSArray arrayWithArray:arr];
}

- (NSArray *)sc_filter:(BOOL (^)(id))block
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        if (block(obj)) {
            [arr addObject:obj];
        }
    }];
    return [NSArray arrayWithArray:arr];
}

- (BOOL)sc_all:(BOOL (^)(id))block
{
    __block BOOL all = self.count > 0;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        if (!block(obj)) {
            all = NO;
            *stop = YES;
        }
    }];
    return all;
}

- (BOOL)sc_any:(BOOL (^)(id))block
{
    __block BOOL any = NO;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        if (block(obj)) {
            any = YES;
            *stop = YES;
        }
    }];
    return any;
}

@end
