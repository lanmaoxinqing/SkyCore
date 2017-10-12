//
//  SCStore.h
//  SkyCore
//
//  Created by sky on 2017/10/12.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCStore : NSObject

+ (instancetype)defaultStore;

@end

@interface SCStore (UserDefaults)

- (id)ud_objectForKey:(NSString *)key;
- (NSString *)ud_stringForKey:(NSString *)key;
- (NSArray *)ud_arrayForKey:(NSString *)key;
- (NSDictionary<NSString *, id> *)ud_dictionaryForKey:(NSString *)key;
- (NSData *)ud_dataForKey:(NSString *)key;
- (NSArray<NSString *> *)ud_stringArrayForKey:(NSString *)key;
- (NSInteger)ud_integerForKey:(NSString *)key;
- (float)ud_floatForKey:(NSString *)key;
- (double)ud_doubleForKey:(NSString *)key;
- (BOOL)ud_boolForKey:(NSString *)key;
- (NSURL *)ud_URLForKey:(NSString *)key;

- (void)ud_setObject:(id <NSCopying>)object forKey:(NSString *)key;


@end

@interface SCStore (File)

@end

@interface SCStore (KeyChain)

@end
