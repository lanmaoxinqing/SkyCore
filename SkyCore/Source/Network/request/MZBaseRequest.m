//
//  MZBaseRequest.m
//  Pods
//
//  Created by Ricky on 16/6/6.
//
//

#import "MZBaseRequest.h"
#import "MZRequestManager.h"
#import "SCStore.h"
#import "MZBaseResponse.h"
#import "MZBaseResponse+CommonErrorSolution.h"
#import "MZCachedRequestManager.h"
#import "MZRequestTransaction.h"

#define kDefaultHttpRequestTimeout 18.0

void mz_dispatch_on_main_queue(dispatch_block_t block) {
    if ([[NSThread currentThread] isMainThread]) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

Class classOfProperty(NSString * propertyName, id obj) {
    // Get Class of property to be populated.
    Class propertyClass = nil;
    objc_property_t property = class_getProperty([obj class], [propertyName UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0)
    {
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    return propertyClass;
}

@interface MZBaseRequest ()

@property (nonatomic, strong) NSURLSessionDataTask *task;
/**
 data
 */
@property (nonatomic, strong) __kindof MZBaseResponse *response;
@property (nonatomic, copy) NSError *error;
/**
 request
 */
@property (nonatomic, strong) id finalParameters;//请求时使用的实际参数，子类可以覆盖getter方法来强制设置参数
@property (nonatomic, copy) MZRequestBlock errorBlock;
@property (nonatomic, copy) MZRequestBlock responseBlock;
@property (nonatomic, copy) MZRequestBlock finishBlock;

@end

@implementation MZBaseRequest

#pragma mark - ==================== settings ================

- (instancetype)init {
    return [self initWithManager:[MZCachedRequestManager defaultManger]];
}

- (instancetype)initWithManager:(MZRequestManager *)manager {
    if (self = [super init]) {
        _manager = manager;
        _timeout = kDefaultHttpRequestTimeout;
        _cacheValidateTime = NSIntegerMax;
        _path = @"";
    }
    return self;
}

#pragma mark subclass override methods
- (MZRequestMethod)method
{
    return MZRequestMethodGet;
}

- (void)setup {
}

- (id)parameters {
    return _parameters ?: [self yy_modelToJSONObject];
}

- (id)finalParameters {
    return _finalParameters ?: [self parameters];
}

- (void)resolveError:(NSError *)error completion:(void (^)(NSError *))completion
{
    //默认不处理，透传error
    completion(error);
}

#pragma mark - ==================== request ================
#pragma mark 新API
+ (instancetype)request
{
    return [[self alloc] init];
}

//- (void)retainHandles {
//    [self.errorBlock copy];
//    [self.responseBlock copy];
//    [self.finishBlock copy];
//}

- (void)releaseHandles {
    _errorBlock = nil;
    _responseBlock = nil;
    _finishBlock = nil;
}

- (void)startWithError:(MZRequestBlock)errorHandle response:(MZRequestBlock)responseHandle finish:(MZRequestBlock)finishHandle {
    self.errorBlock = errorHandle;
    self.responseBlock = responseHandle;
    self.finishBlock = finishHandle;
    
    MZRequestTransactionGroup *group = [[MZRequestTransaction sharedTrasaction] currentTransactionGroup];
    if (group) {
        [group addRequest:self];
        self.finishBlock = finishHandle = ^(__kindof MZBaseRequest *request, NSError *error) {
            [[MZRequestTransaction sharedTrasaction] requestSignalFinish:request];
        };
    }
    
    //取消上一次操作
    [self cancel];
    [self setup];
    
    //请求回调处理
    MZRequestBlock completion = ^(__kindof MZBaseRequest *request, NSError *error) {
        //错误流程
        if (error) {
            [self __onErrorResult:error errorHandle:errorHandle finishHandle:finishHandle];
            [self releaseHandles];
            return;
        }
        [self __onResponseResult:responseHandle finishHandle:finishHandle];
        [self releaseHandles];
    };
    //发起请求
    [self.manager startRequest:self
                     withBlock:completion];
    //增加请求次数
    _retryCount ++;
}

- (__kindof MZBaseRequest *)resend {
    [self startWithError:self.errorBlock response:self.responseBlock finish:self.finishBlock];
    return self;
}

- (__kindof MZBaseRequest *)resume {
    if (self.task){
        [self.task resume];
    }
    return self;
}

- (__kindof MZBaseRequest *)suspend {
    if (self.task){
        [self.task suspend];
    }
    return self;
}

- (__kindof MZBaseRequest *)cancel {
    if (self.task) {
        [self.task cancel];
    }
    else {      // 如果没有 task 说明是 delay 的请求
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    return self;
}

- (BOOL)isCanceled
{
    return self.task.state == NSURLSessionTaskStateCanceling ||
    ([self.task.error.domain isEqualToString:NSURLErrorDomain] && self.task.error.code == NSURLErrorCancelled);
}

#pragma mark 老API
- (void)startWithBlock:(MZRequestBlock)block
{
    [self startWithError:nil response:nil finish:block];
}

- (void)startWithError:(MZRequestBlock)errorHandle finish:(MZRequestBlock)finishHandle {
    [self startWithError:errorHandle response:nil finish:finishHandle];
}

- (void)startWithResponse:(MZRequestBlock)responseHandle finish:(MZRequestBlock)finishHandle {
    [self startWithError:nil response:responseHandle finish:finishHandle];
}

- (void)startWithBlock:(MZRequestBlock)block associatedControl:(UIControl *)control {
    [self startWithBlock:block associatedControls:@[control]];
}

- (void)startWithBlock:(MZRequestBlock)block associatedControls:(NSArray<UIControl *> *)controls {
    for (UIControl *control in controls) {
        control.enabled = NO;
    }
    MZRequestBlock interruptBlock = ^(__kindof MZBaseRequest * request, NSError * error) {
        for (int i = 0; i< controls.count; i++) {
            UIControl *control = controls[i];
            control.enabled = YES;
        }
        block(request, error);
    };
    [self startWithBlock:interruptBlock];
}

- (void)startWithBlock:(MZRequestBlock)block delay:(NSTimeInterval)delay
{
    [self performSelector:@selector(startWithBlock:)
               withObject:block
               afterDelay:delay];
}

#pragma mark - ==================== private ================
- (void)__resolveError:(NSError *)error completion:(void (^)(NSError *))completion {
    [self resolveError:error completion:^(NSError *customError) {
        [MZBaseResponse resolveMZError:customError request:self completion:^(NSError *finalError) {
            completion(finalError);
        }];
    }];
}

- (void)__onErrorResult:(NSError *)finalError errorHandle:(MZRequestBlock)errorHandle finishHandle:(MZRequestBlock)finishHandle {
    self.error = finalError;
    mz_dispatch_on_main_queue(^{
        if (errorHandle) {
            errorHandle(self, finalError);
        }
        if (finishHandle) {
            finishHandle(self, finalError);
        }
    });
}

- (void)__onResponseResult:(MZRequestBlock)responseHandle finishHandle:(MZRequestBlock)finishHandle {
    self.error = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (responseHandle) {
            responseHandle(self, nil);
        }
        mz_dispatch_on_main_queue(^{
            if (finishHandle) {
                finishHandle(self, nil);
            }
        });
    });
}

@end

#pragma mark - ==================== YYModel extension ================

@implementation MZBaseRequest(YYModel)

+ (Class)responseEntityClass
{
    return nil;
    //    NSAssert(nil, @"responseEntityClass can not be nil");
    //    return [NSObject class];
}

+ (NSArray<NSString *> *)modelPropertyBlacklist {
    YYClassInfo *info = [YYClassInfo classInfoWithClass:[MZBaseRequest class]];
    return [info.propertyInfos allKeys];
}

+ (Class)defaultResponseClass {
    if ([self instancesRespondToSelector:@selector(response)]) {
        //        return [self classOfPropertyNamed:@"response"];
        return classOfProperty(@"response", self);
    }
    return [MZBaseResponse class];
}

@end

#pragma mark - ==================== depcerated ================
@implementation MZBaseRequest (Deprecated)
+ (Class)responseClass
{
    return [self defaultResponseClass];
}

- (__kindof MZBaseResponse *)resolveErrorWithResponseObject:(id)response
{
    return nil;
}

- (BOOL)isExternPath
{
    return NO;
}

@end

