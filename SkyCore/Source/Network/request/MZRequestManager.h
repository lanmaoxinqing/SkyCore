//
//  MFRequestManager.h
//  Pods
//
//  Created by Ricky on 16/6/6.
//
//

#import <Foundation/Foundation.h>

@class MZBaseRequest;

typedef NS_ENUM(NSUInteger, MZRequestSerializerType) {
    MZRequestSerializerTypeHttp,
    MZRequestSerializerTypeJson,
    MZRequestSerializerTypePropertyList,
};

typedef void (^MZRequestBlock)(__kindof MZBaseRequest *request, NSError *error);

/**
 测试环境中的URL经过IP转换，此处返回转换后的实际URL
 @return 转换后的URL
 */
FOUNDATION_EXTERN NSURL *MZActualBaseURL(NSURL *url) ;

@interface MZRequestManager : NSObject

@property (nonatomic, copy) NSURL *baseURL;//此处返回原始设置的URL，转换后的真实URL使用`actualBaseURL`获取
@property (nonatomic, assign) BOOL useMockData;

+ (instancetype)defaultManger;
- (instancetype)initWithBaseURL:(NSURL *)baseURL;

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

- (void (^)(id,BOOL))successCallbackForRequest:(MZBaseRequest *)request block:(MZRequestBlock)block;
- (void (^)())failureCallbackForRequest:(MZBaseRequest *)request block:(MZRequestBlock)block;

/**
 同步/异步方式数据解析
 @param request
 @param responseData 服务器响应的原始数据
 @return 经过解析的request对象，解析失败时，error字段不为空
 */
- (__kindof MZBaseRequest *)request:(MZBaseRequest *)request serializeResponse:(NSData *)responseData;
- (void)request:(MZBaseRequest *)request serializeResponse:(NSData *)responseData completion:(MZRequestBlock)block;

/**
 测试环境中的URL经过IP转换，此处返回转换后的实际URL
 @return 转换后的URL
 */
- (NSURL *)actualBaseURL;

#pragma mark - ================ subclass override methods ================
- (void)startRequest:(MZBaseRequest *)request
           withBlock:(MZRequestBlock)block;

@end

@interface MZRequestManager(Filter)

@property (nonatomic, assign) BOOL useHttpsCert;//使用https证书
@property (nonatomic, assign) MZRequestSerializerType requestSerializerType;

@end
