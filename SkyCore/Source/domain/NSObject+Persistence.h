//
//  NSObject+Persistence.h
//  SkyCore
//
//  Created by sky on 14/12/5.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Persistence)

-(void)enumPropertiesUsingBlock:(void (^)(NSString *propertyName,NSUInteger idx,BOOL *stop))block;
+(void)enumPropertiesUsingBlock:(void (^)(NSString *propertyName,NSUInteger idx,BOOL *stop))block;

@end
