//
//  SCStore.h
//  SkyCore
//
//  Created by sky on 2017/10/12.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SCStore : NSObject

+ (instancetype)defaultStore;

@end

@interface SCStore (UserDefaults)


- (nullable id)ud_objectForKey:(NSString *)key;
- (nullable NSString *)ud_stringForKey:(NSString *)key;
- (nullable NSArray *)ud_arrayForKey:(NSString *)key;
- (nullable NSDictionary<NSString *, id> *)ud_dictionaryForKey:(NSString *)key;
- (nullable NSData *)ud_dataForKey:(NSString *)key;
- (nullable NSArray<NSString *> *)ud_stringArrayForKey:(NSString *)key;
- (NSInteger)ud_integerForKey:(NSString *)key;
- (float)ud_floatForKey:(NSString *)key;
- (double)ud_doubleForKey:(NSString *)key;
- (BOOL)ud_boolForKey:(NSString *)key;
- (nullable NSURL *)ud_URLForKey:(NSString *)key;

- (void)ud_setObject:(nullable id <NSCopying>)object forKey:(NSString *)key;


@end

@interface SCStoreFile : NSObject

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSDate *lastModifyDate;
@end

@interface SCStore (File)

/**
 根据key获取文件缓存路径

 @param key key值
 @return 缓存路径
 */
- (NSString *)pathForKey:(NSString *)key;

/**
 缓存数据至文件
 
 @param data 文件数据
 @param key key值
 */
- (void)file_setData:(nullable NSData *)data forKey:(NSString *)key;

/**
 缓存模型至文件（序列化模型至文件）

 @param obj 可序列化的模型
 @param key key值
 */
- (void)file_setObject:(nullable id<NSCoding>)obj forKey:(NSString *)key;
/**
 返回文件数据
 
 @param key key值
 @return 文件数据
 */
- (nullable __kindof SCStoreFile *)fileForKey:(NSString *)key;
/**
 返回模型，如果key对应值不满足<NSCoding>，返回nil
 
 @param key key值
 @return 反序列后的模型
 */
- (nullable id<NSCoding>)file_objectForKey:(NSString *)key;
@end

@interface SCStore (KeyChain)

@end
NS_ASSUME_NONNULL_END
