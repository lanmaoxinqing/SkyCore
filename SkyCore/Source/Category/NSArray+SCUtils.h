//
//  NSArray+MZ.h
//  meizhuang
//
//  Created by Ricky on 16/6/29.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (SCIterator)

//遍历处理数组
- (NSArray *)sc_map:(NS_NOESCAPE id(^)(ObjectType obj))block;
//过滤，保留满足条件项
- (NSArray<__kindof ObjectType> *)sc_filter:(NS_NOESCAPE BOOL(^)(ObjectType obj))block;
//是否有任一满足条件项
- (BOOL)sc_any:(NS_NOESCAPE BOOL(^)(ObjectType obj))block;
//是否全部满足条件
- (BOOL)sc_all:(NS_NOESCAPE BOOL(^)(ObjectType obj))block;

@end
