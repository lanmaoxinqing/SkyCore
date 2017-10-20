//
//  MZBaseResponse.h
//  Meixue
//
//  Created by 郑志勤 on 16/10/20.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZResponseParser.h"

@class MZBaseRequest;

/**
 该子类只在不定返回结果（外部请求）时使用，返回原始数据。内部请使用具体子类。
 */
@interface MZBaseResponse : NSObject

/**
 服务端返回的原始data信息
 */
@property (nonatomic, strong, readonly) NSData *responseData;
/**
 服务端返回的response中的message信息
 */
@property (nonatomic, strong) NSString *responseMessage;
/**
 服务端返回的response中的code信息
 */
@property (nonatomic, strong) NSString *responseCode;
/**
 header信息
 */
@property (nonatomic, strong) NSDictionary *responseHeader;
/**
 相应的parser
 */
@property (nonatomic, strong) __kindof MZResponseParser *parser;
@property (nonatomic, strong) NSError *error;
/**
 是否缓存数据
 */
@property (nonatomic, assign) BOOL isFromCache;

//// 该方法是在子线程环境中执行
//- (id)parse;

+ (instancetype)responseWithResponseData:(NSData *)data;

- (instancetype)initWithResponseData:(NSData *)data;

/**
 将responseData转换为NSArray/NSDictionary,以便进一步处理。
 需在responseData设置后调用。如果已调用过，下次调用会直接返回上次执行的结果。
 */
- (id)jsonObject;
/**
 老接口兼容方案，指定resultEntity到propertyName映射，请使用新方法parseForEntityClass
 */
- (NSError *)parseForEntityName:(NSString *)entityName entityClass:(Class)clazz;

/**
 override point.子类可以覆盖此方法或者设置自定义parser对象来完成解析。
 新接口，可以统一使用resultEntity.
 */
- (NSError *)parseForEntityClass:(Class)clazz;

///////////////////////////////////以下过期方法////////////////////////////////////////////////////
/**
 @param nonatomic <#nonatomic description#>
 @param readonly  <#readonly description#>

 @return <#return value description#>
 */
@property (nonatomic, readonly) id originalResponseObject DEPRECATED_MSG_ATTRIBUTE("Use responseData");

+ (instancetype)responseWithObject:(id)object DEPRECATED_MSG_ATTRIBUTE("Use responseWithResponseData");

- (instancetype)initWithObject:(id)object DEPRECATED_MSG_ATTRIBUTE("Use initWithResponseData");

+ (Class)entityClass DEPRECATED_MSG_ATTRIBUTE("Use [MZBaseRequest responseEntityClass]");

@end
