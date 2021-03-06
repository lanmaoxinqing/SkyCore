//
//  BaseService.m
//  hztour-iphone
//
//  Created by liu ding on 11-12-31.
//  Copyright 2011年 teemax. All rights reserved.
//

#import "SCBaseService.h"
#import "SCBaseDao.h"
#import "SCSysconfig.h"
#import "NSString+md5.h"
#import "SCAppCache.h"
#import "UIKit+AFNetworking.h"

@interface AFHTTPRequestOperationManager (Singleton)

+(instancetype)sharedManager;

@end

@implementation AFHTTPRequestOperationManager (Singleton)

+(instancetype)sharedManager{
    static AFHTTPRequestOperationManager *manager=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager=[[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    });
    return manager;
}

@end

@interface SCBaseService (){
    NSMutableDictionary *fileDic_;
}

@end

#pragma mark -

@implementation SCBaseService

//+(NSOperationQueue *)sharedQueue{
//    static NSOperationQueue *queue=nil;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        queue=[[NSOperationQueue alloc] init];
//    });
//    return queue;
//}

-(instancetype)init{
    self=[super init];
    if(self){
        _manager=[AFHTTPRequestOperationManager sharedManager];
        if([SCSysconfig webAPI])
        self.urlStr=[SCSysconfig webAPI];
    }
    return self;
}

-(void)setUrlStr:(NSString *)urlStr{
    if([urlStr isNotEmpty] && ![urlStr hasPrefix:@"http://"]){
        urlStr=[@"http://" stringByAppendingString:urlStr];
    }
    _urlStr=urlStr;
}

-(void)addParamByKey:(NSString *)key value:(id)value{
    if([key hasPrefix:@"File:"]){
        if(!fileDic_){
            fileDic_=[NSMutableDictionary new];
        }
        NSString *fileName=[key stringByReplacingOccurrencesOfString:@"File:" withString:@""];
        [fileDic_ setObject:value forKey:fileName];
    }else{
        if(!_params){
            _params=[NSMutableDictionary new];
        }
        [_params setObject:value forKey:key];
    }
}

-(NSString *)generateURL{
    NSMutableString *url=[NSMutableString string];
    if(_urlStr){
        [url appendString:_urlStr];
    }
    if(_action){
        [url appendFormat:@"/%@",_action];
    }
    //c#
    if(_service){
        [url appendFormat:@"/%@",_service];
        if(_method){
            [url appendFormat:@"/%@",_method];
        }
    }
    //java
    else{
        if(_method){
            [url appendFormat:@"!%@",_method];
        }
    }
    return url;
}

-(NSString *)description{
    NSString *urlStr=[self generateURL];
    NSURL *url=[NSURL URLWithString:urlStr relativeToURL:[NSURL URLWithString:[SCSysconfig webAPI]]];
    urlStr=url.absoluteString;
    NSMutableArray *arr=[NSMutableArray new];
    for(NSString *key in [_params allKeys]){
        NSString *str=[key stringByAppendingFormat:@"=%@",[_params[key] isNotEmpty]?_params[key]:@""];
        [arr addObject:str];
    }
    NSString *params=[arr componentsJoinedByString:@"&"];
    if(params){
        urlStr=[urlStr stringByAppendingFormat:@"?%@",params];
    }
    return urlStr;
}

#pragma mark - POST请求
-(AFHTTPRequestOperation *)request:(void (^)(NSString *, NSString *))finish{
    return [self.manager POST:[self generateURL] parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(finish){
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            finish(responseString,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败\n%@\n%@",[self description],[error description]);
        if(finish){
            finish(nil,@"请求失败");
        }
    }];
}

-(AFHTTPRequestOperation *)requestWithProgressBlock:(void (^)(NSUInteger, long long, long long))block finish:(void (^)(NSString *, NSString *))finish{
    if([fileDic_ isNotEmpty]){
        return [self uploadWithProgressBlock:block finish:finish];
    }else{
        return [self request:finish];
    }
}

#pragma mark - 下载
-(AFHTTPRequestOperation *)download:(void (^)(NSString *, NSString *))finish{
    return [self downloadWithProcess:nil finish:finish append:NO];
}

-(AFHTTPRequestOperation *)download:(void (^)(NSString *, NSString *))finish append:(BOOL)append{
    return [self downloadWithProcess:nil finish:finish append:append];
}

-(AFHTTPRequestOperation *)downloadWithProcess:(void (^)(NSUInteger, long long, long long))processBlock finish:(void (^)(NSString *, NSString *))finish append:(BOOL)append{
//    if(![SCSysconfig isNetworkReachable]){
//        [self showSuggestion:@"无法连接网络"];
//        return nil;
//    }
    NSString *url=[self generateURL];
    if(!_downloadPath){
        self.downloadPath=[SCSysconfig filePathByName:url];
    }
    AFHTTPRequestOperation *operation=[self.manager POST:url parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(finish){
            finish(_downloadPath,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败\n%@\n%@",[self description],[error description]);
        if(finish){
            finish(nil,@"下载失败");
        }
    }];
    if(processBlock){
        [operation setDownloadProgressBlock:processBlock];
    }
    operation.outputStream=[NSOutputStream outputStreamToFileAtPath:_downloadPath append:append];
    return operation;
}

-(void)showSuggestion:(NSString *)info{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window showSuggestion:info];
}

#pragma mark - 上传
-(AFHTTPRequestOperation *)upload:(void (^)(NSString *, NSString *))finish{
    return [self uploadWithProgressBlock:nil finish:finish];
}

-(AFHTTPRequestOperation *)uploadWithProgressBlock:(void (^)(NSUInteger, long long, long long))block finish:(void (^)(NSString *, NSString *))finish{
    if(![fileDic_ isNotEmpty]){
        if(finish) finish(nil,@"未选择上传文件");
        return nil;
    }
    NSString *fileName=[fileDic_ allKeys][0];
    id value=[fileDic_ objectForKey:fileName];
    NSString *filePath=nil;
    if([value isKindOfClass:[NSString class]]){
        filePath=value;
    }else if([value isKindOfClass:[NSArray class]] && [value count]>0){
        filePath=value[0];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        if(finish) finish(nil,@"上传文件不存在");
        return nil;
    }
    AFHTTPRequestOperation *operation=[self.manager POST:[self generateURL] parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[self urlForPath:filePath] name:fileName error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(finish){
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            finish(responseString,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败\n%@\n%@",[self description],[error description]);
        if(finish){
            finish(nil,@"上传失败");
        }
    }];
    if(block){
        [operation setUploadProgressBlock:block];
    }
    return operation;
}

-(void)batchUploadWithProgressBlock:(void (^)(NSUInteger, NSUInteger))progressBlock finish:(void (^)(NSArray *, NSString *))finish{
    if(![fileDic_ isNotEmpty]){
        if(finish) finish(nil,@"未选择上传文件");
        return;
    }
    NSMutableArray *operationList=[NSMutableArray new];
    for(NSString *key in fileDic_){
        id value=[fileDic_ objectForKey:key];
        if([value isKindOfClass:[NSString class]]){
            if(![[NSFileManager defaultManager] fileExistsAtPath:value]){
                continue;
            }
            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[self generateURL] parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileURL:[self urlForPath:value] name:key error:nil];
            } error:nil];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operationList addObject:operation];
        }else if([value isKindOfClass:[NSArray class]] && [value count]>0){
            NSArray *files=[fileDic_ objectForKey:key];
            for(NSString *filePath in files){
                if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                    continue;
                }
                NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[self generateURL] parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFileURL:[self urlForPath:filePath] name:key error:nil];
                } error:nil];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                [operationList addObject:operation];
            }
        }
    }
    if(![operationList isNotEmpty]){
        if(finish) finish(nil,@"上传文件不存在");
        return;
    }
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:operationList progressBlock:progressBlock completionBlock:^(NSArray *operations) {
        if(finish) finish(operations,nil);
    }];
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];

}

-(NSURL *)urlForPath:(NSString *)path{
    NSURL *url=nil;
    if(path){
        if([path hasPrefix:@"http://"]){
            url=[NSURL URLWithString:path];
        }else{
            url=[NSURL fileURLWithPath:path];
        }
    }
    return url;
}

@end

