//
//  MZBaseRequest.h
//  Pods
//
//  Created by Ricky on 16/6/6.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "MZErrorCode.h"
#import "MZRequestManager.h"

@class MZBaseResponse, MZBaseRequest;

@protocol AFMultipartFormData;

@protocol MZFileAttachment <NSObject>
@optional
- (void)attachFileWithFormData:(id<AFMultipartFormData>)formData;
@end


typedef NS_ENUM(NSInteger, MZRequestMethod) {
    MZRequestMethodGet      = 0,
    MZRequestMethodPost,
    MZRequestMethodPut,
    MZRequestMethodDelete
};

typedef NS_ENUM(NSUInteger, MZRequestCachePolicy) {
    MZRequestCachePolicyIgnoringCacheData           = 0, //不使用缓存，只远程读取
    MZRequestCachePolicyReturnLoadElseCacheData     = 1, //远程读取，如果失败，则读取缓存
    MZRequestCachePolicyReturnCacheDataElseLoad     = 2, //有缓存时只使用缓存，无缓存时远程读取
    MZRequestCachePolicyIgnoringLoad                = 3, //不读取远程数据，只使用缓存
    MZRequestCachePolicyReturnCacheAndRefreshCache  = 4, // 返回旧的缓存数据，同时发请求更新缓存
};

extern void mz_dispatch_on_main_queue(dispatch_block_t block);


@interface MZBaseRequest : NSObject

@property (nonatomic, assign, readonly) MZRequestManager *manager;//默认为[MZRequestManager defaultManager]
@property (nonatomic, assign) MZRequestCachePolicy cachePolicy;//缓存策略
@property (nonatomic, assign) NSTimeInterval cacheValidateTime;//缓存有效期(默认NSIntegerMax)
@property (nonatomic, copy) NSString *path;//请求路径
@property (nonatomic, strong) id parameters;//原始请求参数，未设置时读取子类的各property字段
@property (nonatomic, strong, readonly) id finalParameters;//请求时的实际参数（加密或修改后等）
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, assign) NSTimeInterval timeout;//请求超时时间，默认为 18 秒
@property (nonatomic, readonly, assign) int retryCount;//该请求的重试次数,调用者应防止无限重试.

@property (nonatomic, strong, readonly) __kindof MZBaseResponse *response;
@property (nonatomic, readonly, copy) NSError *error;
@property (nonatomic, readonly, getter=isCanceled) BOOL canceled;

//MARK:- subclass override methods
/**
 *  请求方法，默认为 GET
 *
 *  @return MZRequestMethod
 */
- (MZRequestMethod)method;

/**
 设置请求相关参数，如path，parameters等
 */
- (void)setup NS_REQUIRES_SUPER;
/**
 该方法提供一次自定义处理error的机会，由子类实现。默认透传error
 @param error      出现的错误
 @param completion 处理完成后的回调，如错误已解决，error应传nil
 */
- (void)resolveError:(NSError *)error completion:(void (^)(NSError *))completion;

//MARK:- public methods

//MARK: initialize methods
+ (instancetype)request;
- (instancetype)initWithManager:(MZRequestManager *)manager NS_DESIGNATED_INITIALIZER;

//MARK: request covenient methods
/**
 *  发起请求,同时屏蔽控件响应,请求结束后恢复
 *
 *  @param block   即新API中的finishHandle
 *  @param control 关联的control
 */
- (void)startWithBlock:(MZRequestBlock)block NS_REQUIRES_SUPER;
- (void)startWithBlock:(MZRequestBlock)block associatedControl:(UIControl *)control NS_REQUIRES_SUPER;
- (void)startWithBlock:(MZRequestBlock)block associatedControls:(NSArray<UIControl *> *)controls NS_REQUIRES_SUPER;
/**
 *  延迟发起请求
 *
 *  @param block  接收回调的 Block
 *  @param delay 延迟秒数
 */
- (void)startWithBlock:(MZRequestBlock)block delay:(NSTimeInterval)delay NS_REQUIRES_SUPER;

//MARK: request methods
/**
 发起网络请求
 
 @param errorHandle    发生错误时的回调。用于错误处理。在主线程。
 @param responseHandle 数据响应回调。用于数据定制，在子线程。
 @param finishHandle   结束回调。用于界面更新，在主线程。
 */
- (void)startWithError:(MZRequestBlock)errorHandle finish:(MZRequestBlock)finishHandle NS_REQUIRES_SUPER;
- (void)startWithResponse:(MZRequestBlock)responseHandle finish:(MZRequestBlock)finishHandle NS_REQUIRES_SUPER;
- (void)startWithError:(MZRequestBlock)errorHandle response:(MZRequestBlock)responseHandle finish:(MZRequestBlock)finishHandle NS_REQUIRES_SUPER;

//MARK: other
/**
 其他请求操作
 */
- (__kindof MZBaseRequest *)resend;//重发请求（不再设置过滤参数）
- (__kindof MZBaseRequest *)resume;//恢复
- (__kindof MZBaseRequest *)suspend;//挂起
- (__kindof MZBaseRequest *)cancel;//取消

@end

//MARK:- YYModel support
@interface MZBaseRequest(YYModel)<YYModel>

+ (Class)defaultResponseClass;

/**
 用于指定response解析对象或数组时使用的类
 */
+ (Class)responseEntityClass;

+ (NSArray<NSString *> *)modelPropertyBlacklist NS_REQUIRES_SUPER;
@end

#pragma mark - ==================== deprecated ================
@interface MZBaseRequest(Deprecated)
///**
// *  取消请求
// */
//- (void)cancel;

- (BOOL)isExternPath NS_DEPRECATED_IOS(2_0, 2_0, "WILL DEPRECATED");

// Override points

/**
 *  响应的 Class，用于实例化为数据模型对象，默认为 MZBaseResponse
 *
 *  @return Class
 */
+ (Class)responseClass NS_DEPRECATED_IOS(2_0, 2_0, "WILL DEPRECATED");

/**
 *  提供一次机会让子类解决错误，成为正常的返回。如果返回 nil，说明是错误，non-nil 将用它作为
 *  返回数据
 *
 *  @param response 服务器返回的原始 @c JSON 数据
 *
 *  @return 子类修改后的返回数据
 */
- (__kindof MZBaseResponse *)resolveErrorWithResponseObject:(id)response NS_DEPRECATED_IOS(2_0, 2_0, "WILL DEPRECATED");

@end

