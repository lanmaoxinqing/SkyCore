//
//  SCStore.m
//  SkyCore
//
//  Created by sky on 2017/10/12.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import "SCStore.h"
#import "SCApplication.h"
#import <SFHFKeychainUtils/SFHFKeychainUtils.h>

@interface SCStore()

@property(nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, copy) NSString *rootPath;

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
        self.rootPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Cache"] stringByAppendingPathComponent:SCApplication.bundleIdentifier];
        BOOL isDirectory;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.rootPath isDirectory:&isDirectory];
        if (!fileExists || !isDirectory) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:self.rootPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NSString *errorInfo = [NSString stringWithFormat:@"文件缓存根目录创建失败！\n%@", error.localizedDescription];
                NSAssert(NO, errorInfo);
            }
        }
    }
    return self;
}

@end


@implementation SCStore (UserDefaults)

- (NSObject<NSCopying> *)ud_objectForKey:(NSString *)key {
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

@implementation SCStoreFile
@end

@implementation SCStore (File)

- (NSString *)pathForKey:(NSString *)key {
    return [self.rootPath stringByAppendingPathComponent:key];
}

- (void)file_setData:(NSData *)data forKey:(NSString *)key {
    [data writeToFile:[self pathForKey:key] atomically:YES];
}

- (void)file_setObject:(id<NSCoding>)obj forKey:(NSString *)key {
    [NSKeyedArchiver archiveRootObject:obj toFile:[self pathForKey:key]];
}

- (NSObject<NSCoding> *)file_objectForKey:(NSString *)key {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForKey:key]];
}

-(SCStoreFile *)file_storeFileForKey:(NSString *)key {
    NSData *fileData = nil;
    NSDate *lastModifyDate = nil;
    NSString *fileFullPath = [self pathForKey:key];
    if (fileFullPath.length > 0) {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        fileData = [fileMgr contentsAtPath:fileFullPath];
        NSDictionary *fileAttributes = [fileMgr attributesOfItemAtPath:fileFullPath error:nil];
        lastModifyDate = fileAttributes[NSFileModificationDate] ?: fileAttributes[NSFileCreationDate];
    }
    
    SCStoreFile *file = [SCStoreFile new];
    file.path = fileFullPath;
    file.data = fileData;
    file.lastModifyDate = lastModifyDate;
    
    return file;
}

@end

@implementation SCStore (KeyChain)

- (NSString *)kc_stringForKey:(NSString *)key {
    NSError *error = nil;
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:key
                                                    andServiceName:@"skycore"
                                                             error:&error];
    if (error) {
        return nil;
    }
    return password;
}

- (void)kc_setString:(NSString *)string forKey:(NSString *)key {
    NSError *error = nil;
    [SFHFKeychainUtils storeUsername:key
                         andPassword:string
                      forServiceName:@"skycore"
                      updateExisting:YES
                               error:&error];
    
}

@end
