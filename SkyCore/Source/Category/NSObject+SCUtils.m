//
//  NSObject+SCUtils.m
//  SkyCore
//
//  Created by 心情 on 2017/10/20.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import "NSObject+SCUtils.h"
#import <objc/runtime.h>

@implementation NSObject(NotNull)

- (BOOL)sc_isNotNull{
    if(self != nil && self != NULL && (NSNull *)self != [NSNull null]){
        return YES;
    }
    return NO;
}

- (BOOL)sc_isNotEmpty{
    if ([self respondsToSelector:@selector(count)]) {
        return [self performSelector:@selector(count)] > 0;
    }
    if ([self respondsToSelector:@selector(length)]) {
        return [self performSelector:@selector(length)] > 0;
    }
    return [self sc_isNotNull];
}

@end

@implementation NSObject (PropertyClass)

- (Class)sc_classOfProperty:(NSString *)propertyName {
    return [[self class] sc_classOfProperty:propertyName];
}
+ (Class)sc_classOfProperty:(NSString *)propertyName {
    objc_property_t property = class_getProperty(self, [propertyName UTF8String]);
    if (property == NULL) {
        return nil;
    }
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count == 0) {
        return nil;
    }
    NSString *encodeType = splitPropertyAttributes[0];
    NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
    NSString *className = splitEncodeType[1];
    return NSClassFromString(className);
}

@end

