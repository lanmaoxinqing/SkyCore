//
//  SCStore.m
//  SkyCore
//
//  Created by sky on 2017/10/12.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import "SCStore.h"

@interface SCStore()

@property(nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation SCStore

+ (instancetype)defaultStore {
    static dispatch_once_t onceToken;
    static SCStore *sc_store = nil;
    dispatch_once(&onceToken, ^{
        sc_store = [[SCStore alloc] init];
    });
    return sc_store;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.sky.core"];
    }
    return self;
}

@end


@implementation SCStore (UserDefaults)

- (id)ud_objectForKey:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    return [self.userDefaults objectForKey:key];
}

- (NSString *)ud_stringForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [self.userDefaults stringForKey:key];
}

- (NSArray *)ud_arrayForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [self.userDefaults arrayForKey:key];
}

- (NSDictionary<NSString *,id> *)ud_dictionaryForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [self.userDefaults dictionaryForKey:key];
}

- (NSData *)ud_dataForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [self.userDefaults dataForKey:key];
}

- (NSArray<NSString *> *)ud_stringArrayForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [self.userDefaults stringArrayForKey:key];
}

- (NSInteger)ud_integerForKey:(NSString *)key {
    if (key == nil) {
        return 0;
    }
    return [self.userDefaults integerForKey:key];
}

- (float)ud_floatForKey:(NSString *)key {
    if (key == nil) {
        return 0;
    }
    return [self.userDefaults floatForKey:key];
}

- (double)ud_doubleForKey:(NSString *)key {
    if (key == nil) {
        return 0;
    }
    return [self.userDefaults doubleForKey:key];
}

- (BOOL)ud_boolForKey:(NSString *)key {
    if (key == nil) {
        return NO;
    }
    return [self.userDefaults boolForKey:key];
}

- (NSURL *)ud_URLForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [self.userDefaults URLForKey:key];
}

- (void)ud_setObject:(id <NSCopying>)object forKey:(NSString *)key
{
    if (key == nil) {
        return;
    }
    [self.userDefaults setObject:object forKey:key];
    [self.userDefaults synchronize];
}


@end

@implementation SCStore (File)

@end

@implementation SCStore (KeyChain)

@end
