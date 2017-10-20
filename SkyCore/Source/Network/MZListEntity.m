//
//  MZListEntity.m
//  meizhuang
//
//  Created by Ricky on 16/8/12.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <objc/runtime.h>

#import "MZListEntity.h"

@interface MZListEntity()
///**
// 埋点用
// */
//@property (nonatomic, copy) NSString *pvid;
//@property (nonatomic, copy) NSString *abtest;

@end
@implementation MZListEntity

- (Class)listEntityClass:(id)entity {
    return [entity class];
}

@end

//@implementation MZListEntity(UT)
//
//@end
