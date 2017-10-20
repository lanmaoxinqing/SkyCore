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

@interface __MZObserverRemover : NSObject
@property (nonatomic, weak) id<NSObject> observer;
@end

@implementation __MZObserverRemover

+ (instancetype)removerWithObserver:(id<NSObject>)observer
{
    __MZObserverRemover *remover = [[self alloc] init];
    remover.observer = observer;
    return remover;
}

- (void)dealloc
{
    if (self.observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    }
}

@end

@implementation NSObject (NotificationCenter)

- (NSMutableDictionary <NSString *, __MZObserverRemover *> *)nc_observerDictionary
{
    NSMutableDictionary <NSString *, __MZObserverRemover *> * dic = objc_getAssociatedObject(self, @selector(nc_observerDictionary));
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(nc_observerDictionary), dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

- (void)observeNotificationName:(NSString *)name object:(id)object inQueue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *noti))block
{
    NSString *key = [NSString stringWithFormat:@"%@-%p", name, object];
    
    [self nc_observerDictionary][key] = [__MZObserverRemover removerWithObserver:[[NSNotificationCenter defaultCenter] addObserverForName:name
                                                                                                                                   object:object
                                                                                                                                    queue:queue
                                                                                                                               usingBlock:block]];
}

- (void)observeNotificationName:(NSString *)name object:(id)object usingBlock:(void (^)(NSNotification *noti))block
{
    [self observeNotificationName:name object:object inQueue:[NSOperationQueue currentQueue] usingBlock:block];
}

- (void)unobserveNotificationName:(NSString *)name object:(id)object
{
    NSString *key = [NSString stringWithFormat:@"%@-%p", name, object];
    [self nc_observerDictionary][key] = nil;
}

@end
