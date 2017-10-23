//
//  MZBaseResponse.m
//  Meixue
//
//  Created by 郑志勤 on 16/10/20.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZBaseResponse.h"
#import "MZErrorCode.h"
#import "MZBaseResponse+CommonErrorSolution.h"

@interface MZBaseResponse()
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) id responseJson;
@property (nonatomic, strong) id originalResponseObject DEPRECATED_MSG_ATTRIBUTE("Use responseData");
@end

@implementation MZBaseResponse

- (instancetype)init
{
    return [self initWithResponseData:nil];
}

- (instancetype)initWithResponseData:(NSData *)data
{
    if (self = [super init]) {
        self.responseData = data;
    }
    return self;
}

+ (instancetype)responseWithResponseData:(NSData *)data
{
    return [[self alloc] initWithResponseData:data];
}

+ (Class)entityClass
{
    return [NSObject class];
}

- (NSError *)parseForEntityName:(NSString *)entityName entityClass:(Class)clazz {
    if (!self.parser) {
        self.parser = [[MZResponseParser alloc] initWithResponse:self];
    }
    return [self.parser parseForItemClass:clazz];
}

- (NSError *)parseForEntityClass:(Class)clazz
{
    return [self parseForEntityName:nil entityClass:clazz];
}

- (id)jsonObject {
    if (_responseJson) {
        return _responseJson;
    }
    NSError *error;
    if (!self.responseData) {//crash保护
        return nil;
    }
    _responseJson = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&error];
    return _responseJson;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // do noting
//    MZLogError(@"error : response undefinedKey[%s_%@]", __func__, key);
}

/**
 以下方法待删除

 @param instancetype <#instancetype description#>

 @return <#return value description#>
 */
+ (instancetype)responseWithObject:(id)object
{
    return [[self alloc] initWithObject:object];
}

//- (instancetype)init
//{
//    return [self initWithObject:nil];
//}

- (instancetype)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        self.originalResponseObject = object;
    }
    return self;
}

@end
