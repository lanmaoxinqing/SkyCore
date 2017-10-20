//
//  MFRequestManager.m
//  Pods
//
//  Created by Ricky on 16/6/6.
//
//

#import <AFNetworking/AFNetworking.h>

#import "MZCachedRequestManager.h"
#import "MZBaseRequest.h"

#import "MZBaseResponse+CommonErrorSolution.h"

static NSString * const baseUrl = @"https://api.mei.163.com/";

NSURL *MZActualBaseURL(NSURL *url) {
#if (DEBUG || CI) && !TARGET_OS_SIMULATOR
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if ([EtcHostsURLProtocol canInitWithRequest:request]) {
        url = [EtcHostsURLProtocol canonicalRequestForRequest:request].URL;
    }
#endif
    return url;
}


@interface MZBaseRequest(Manager)

@property (nonatomic, strong) MZBaseResponse *response;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation MZBaseRequest(Manager)
@dynamic response, task, error;

@end

@interface MZRequestManager ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, assign) BOOL useHttpsCert;
@property (nonatomic, assign) MZRequestSerializerType requestSerializerType;

@end

@implementation MZRequestManager

//static NSString * const baseUrl = @"http://feature2.cms.mei.netease.com/";

+ (instancetype)defaultManger
{
    static MZRequestManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    if (!manager.baseURL) {
        manager.baseURL = [NSURL URLWithString:baseUrl];
    }
    return manager;
}

- (void)dealloc
{
    [self.manager invalidateSessionCancelingTasks:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    self = [super init];
    if (self) {
        [self setup];
        self.baseURL = baseURL;
    }
    return self;
}

- (void)setup {
    //网络环境变化时，更新header信息
    @weakify(self)
    [self observeNotificationName:AFNetworkingReachabilityDidChangeNotification object:nil usingBlock:^(NSNotification *noti) {
        @strongify(self)
    }];
}

- (void)setBaseURL:(NSURL *)baseURL
{
    if (![_baseURL isEqual:baseURL]) {
        _baseURL = baseURL;

        if (self.manager) {
            [self.manager invalidateSessionCancelingTasks:YES];
        }
        
        // add customized NSURLProtocol into chain
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        configuration.timeoutIntervalForRequest = 15;
        configuration.HTTPShouldUsePipelining = YES;
        // 以下在 iOS 8 中不 work ，原因未知，先在 requestSerializer 上直接加 header
        // configuration.HTTPAdditionalHeaders = @{@"X-MZApp": [MZAppConfig defaultConfig].mz_appCustomHeader ?: @""};
        //        NSMutableArray *mArray = [NSMutableArray arrayWithArray:[MZAppConfig defaultConfig].mz_URLProtocolClasses];
        //        [mArray addObjectsFromArray:conf.protocolClasses];
        //        conf.protocolClasses = mArray;
        
        
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:_baseURL sessionConfiguration:configuration];
        self.manager.requestSerializer.timeoutInterval = 15;
        
        // 以下为了防止每个 request 都读一次磁盘，取 cert 的内容
        if ([_baseURL.scheme isEqualToString:@"https"]) {
            self.useHttpsCert = YES;
        }
        else {
            self.useHttpsCert = NO;
        }
        
        //更改responseSerializer为AFHTTPResponseSerializer,提供服务器响应的原始数据
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSMutableSet *acceptSerializer = [self.manager.responseSerializer.acceptableContentTypes mutableCopy];
        [acceptSerializer addObject:@"text/plain"];
        [(AFHTTPResponseSerializer *)self.manager.responseSerializer setAcceptableContentTypes:acceptSerializer];
        
    }
}

- (NSURL *)actualBaseURL {
    return MZActualBaseURL(self.baseURL);
}

- (__kindof MZBaseRequest *)request:(MZBaseRequest *)request serializeResponse:(NSData *)responseData {
    request.response = [[[[request class] defaultResponseClass] alloc] initWithResponseData:responseData];
    request.response.responseHeader = [(NSHTTPURLResponse *)request.task.response allHeaderFields];
    NSError *error  = [request.response parseForEntityClass:[[request class] responseEntityClass]];
    //解析出错
    if (error) {
        request.error = error;
        return request;
    }
    //服务器返回错误码
    if ([request.response.responseCode integerValue] != 200) {
        NSInteger code = [request.response.responseCode integerValue];
        NSString *message = @"网络异常，请重试";
        if (request.response.responseMessage.length > 0) {
            message = request.response.responseMessage;
        }
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:message forKey:NSLocalizedDescriptionKey];
        if (request.task.currentRequest.URL) {
            [userInfo setObject:request.task.currentRequest.URL forKey:NSURLErrorFailingURLErrorKey];
        }
        error = [NSError errorWithDomain:MZRequestErrorDomain
                                             code:code
                                         userInfo:userInfo];
        request.error = error;
        return request;
    }
    //解析成功
    request.error = nil;
    return request;
}

- (void)request:(MZBaseRequest *)request serializeResponse:(NSData *)responseData completion:(MZRequestBlock)block{
    //1.response生成
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MZBaseRequest *resultRequest = [self request:request serializeResponse:responseData];
        mz_dispatch_on_main_queue(^{
            block(resultRequest, resultRequest.error);
        });
    });
}

- (void (^)(id,BOOL))successCallbackForRequest:(MZBaseRequest *)request block:(MZRequestBlock)block {
    void (^successBlock)(id,BOOL) = ^(id responseObject, BOOL isFromCache) {
        [self request:request serializeResponse:responseObject completion:^(__kindof MZBaseRequest *request, NSError *error) {
            request.response.isFromCache = isFromCache;
            //错误处理
            [request resolveError:error completion:^(NSError *customError) {
                [MZBaseResponse resolveMZError:customError request:request completion:^(NSError *finalError) {
                    if (block) {
                        block(request, finalError);
                    }
                }];
            }];
        }];
    };
    return successBlock;
}

- (void (^)())failureCallbackForRequest:(MZBaseRequest *)request block:(MZRequestBlock)block {
    void (^failureBlock)() = ^(NSError *error) {
        //错误处理
        [MZBaseResponse resolveHTTPError:error request:request completion:^(NSError *finalError) {
            if (block) {
                block(request, finalError);
            }
        }];
    };
    return failureBlock;
}

- (void)startRequest:(MZBaseRequest *)request
           withBlock:(MZRequestBlock)block
{
#if DEBUG || CI
    NSTimeInterval startTime = CFAbsoluteTimeGetCurrent();
#endif
    void(^successBlock)() = ^(NSURLSessionDataTask * task, id responseObject) {
#if DEBUG || CI
        NSTimeInterval endTime = CFAbsoluteTimeGetCurrent();
        static const BOOL debug = YES;
        if (debug) {
            NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            if (jsonObj != nil) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                if (endTime - startTime > .5) {
//                    MZLogWarning(@"[RESPONSE] Long duration time! <%@> (%.3fs) : %@", request.path, endTime-startTime, jsonString);
                }
                else {
//                    MZLogDebug(@"[RESPONSE] <%@> (%.3fs) : %@", request.path, endTime-startTime, jsonString);
                }
            }
        }
#endif
        void (^successCallback)(id,BOOL) = [self successCallbackForRequest:request block:block];
        successCallback(responseObject, NO);
    };
    
    void (^failureBlock)() = ^(NSURLSessionDataTask * task, NSError * error) {
        // 连接被重置，简单打个点
        if ([error.domain isEqualToString:NSPOSIXErrorDomain] && error.code == NSURLErrorConnectionResetByPeer) {
//            MZTrackBuildDebug(MZDebugEvent_ConnectionResetByPeer, nil);
        }
        void (^failureCallback)() = [self failureCallbackForRequest:request block:block];
        failureCallback(error);
#if DEBUG
        NSTimeInterval endTime = CFAbsoluteTimeGetCurrent();
//        MZLogError(@"[RESPONSE] <%@> (%.3fs) : %@", request.path, endTime-startTime, error);
#endif
    };
    
    NSURLSessionDataTask * task = nil;
    NSString *path = request.path;
    //  目前在URL中参数为空就会得到path为空
    if (path == nil) {
        NSError *error = [NSError mz_commonLocalSystemErrorWithCode:MZErrorLocalRequestParamInvalid];
        failureBlock(nil,error);
        return;
    }
    
    AFHTTPSessionManager *manager = self.manager;
    NSURLComponents *components = [NSURLComponents componentsWithString:path];
    if (components.host && ![components.host isEqualToString:self.manager.baseURL.host]) {
        manager = [AFHTTPSessionManager manager];
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableSet *acceptableContentTypes = [self.manager.responseSerializer.acceptableContentTypes mutableCopy];
        [acceptableContentTypes addObject:@"text/plain"];
        responseSerializer.acceptableContentTypes = acceptableContentTypes;
        
        manager.responseSerializer = responseSerializer;
    }
    manager.requestSerializer.timeoutInterval = request.timeout;
    switch (request.method) {
        case MZRequestMethodPost: {
            if ([request respondsToSelector:@selector(attachFileWithFormData:)]) {
                task = [manager POST:path
                          parameters:[request finalParameters]
           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
               if ([request respondsToSelector:@selector(attachFileWithFormData:)]) {
                   [(id<MZFileAttachment>)request attachFileWithFormData:formData];
               }
           }
                            progress:NULL
                             success:successBlock
                             failure:failureBlock];
            }
            else {
                task = [manager POST:path
                          parameters:[request finalParameters]
                            progress:^(NSProgress * _Nonnull uploadProgress) {
                                
                            }
                             success:successBlock
                             failure:failureBlock];
            }
            break;
        }
        case MZRequestMethodPut: {
            task = [manager PUT:path
                     parameters:[request finalParameters]
                        success:successBlock
                        failure:failureBlock];
            break;
        }
        case MZRequestMethodDelete: {
            task = [manager DELETE:path
                        parameters:[request finalParameters]
                           success:successBlock
                           failure:failureBlock];
            break;
        }
        default: {
            task = [manager GET:path
                     parameters:[request finalParameters]
                       progress:NULL
                        success:successBlock
                        failure:failureBlock];
            break;
        }
    }
    request.task = task;
}


- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [self.manager.requestSerializer setValue:value
                          forHTTPHeaderField:field];
}

- (void)setUseMockData:(BOOL)useMockData
{
    _useMockData = useMockData;
    if (_useMockData) {
        self.baseURL = [NSBundle mainBundle].resourceURL;
    }
}


- (void)setUseHttpsCert:(BOOL)useHttpsCert {
    if (_useHttpsCert != useHttpsCert) {
        _useHttpsCert = useHttpsCert;
        if (useHttpsCert) {
            NSString *resPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"der"];
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:resPath];
            AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey
                                                        withPinnedCertificates:[NSSet setWithObjects:data, nil]];
            self.manager.securityPolicy = policy;
        } else {
            self.manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        }
    }
}

- (void)setRequestSerializerType:(MZRequestSerializerType)requestSerializerType {
    @synchronized (self.manager.requestSerializer) {
        _requestSerializerType = requestSerializerType;
        
        AFHTTPRequestSerializer *originSerializer = self.manager.requestSerializer;
        AFHTTPRequestSerializer *serializer = nil;
        
        switch (requestSerializerType) {
            case MZRequestSerializerTypeHttp:
                serializer = [AFHTTPRequestSerializer serializer];
                break;
            case MZRequestSerializerTypeJson:
                serializer = [AFJSONRequestSerializer serializer];
                break;
            case MZRequestSerializerTypePropertyList:
                serializer = [AFPropertyListRequestSerializer serializer];
                break;
            default:
                break;
        }
        //从原请求序列化中赋值
        NSDictionary *httpHeader = [originSerializer HTTPRequestHeaders];
        [httpHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [serializer setValue:obj forHTTPHeaderField:key];
        }];
        serializer.cachePolicy = originSerializer.cachePolicy;
        serializer.timeoutInterval = originSerializer.timeoutInterval;
        //设置新的请求序列化
        self.manager.requestSerializer = serializer;
    }
}
@end

@implementation MZRequestManager (Filter)
@dynamic useHttpsCert;
@dynamic requestSerializerType;

@end
