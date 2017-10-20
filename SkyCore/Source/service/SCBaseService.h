//
//  BaseService.h
//  hztour-iphone
//
//  Created by liu ding on 11-12-31.
//  Copyright 2011年 teemax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/**
 服务器通信基类,提供POST网络请求,文件下载,上传,
 子类可重写`-generateURL`实现自定义URL拼接,默认url拼接方式如下
 c#     urlStr/action/service/method
 java   urlStr/action!method
 */
@interface SCBaseService : NSObject {

}
@property(nonatomic,copy) NSString *urlStr;         //默认使用[SCSysconfig webAPI]作为根路径
@property(nonatomic,copy) NSString *action;         //操作名
@property(nonatomic,copy) NSString *service;        //服务名
@property(nonatomic,copy) NSString *method;         //方法名
@property(nonatomic,copy) NSString *downloadPath;   //下载文件保存地址,默认使用[SCSysconfig filePathByName:[self url]]
//@property(nonatomic,strong,readonly) NSMutableDictionary *headers;  //头信息
@property(readonly,nonatomic,strong) NSMutableDictionary *params;   //传递参数
@property(readonly,nonatomic,strong) AFHTTPSessionManager *manager;
/**
 *  为网络请求添加参数
 *
 *  @param key   参数名
 *  @param value 参数值
 */
-(void)addParamByKey:(NSString *)key value:(id)value;
/**
 *  发起网络请求并回调服务器响应结果
 *
 *  @param finish 回调函数
 *
 *  @return 创建的网络请求Operation,供后续操作
 */
-(NSURLSessionDataTask *)request:(void (^)(id responseObject,NSString *error))finish;
/**
 *  发起带进度的网络请求并回调服务器响应结果,适用文件上传
 *
 *  @param block  上传进度回调
 *  @param finish 网络请求完成回调
 *
 *  @return 创建的网络请求Operation,供后续操作
 */
-(NSURLSessionDataTask *)requestWithProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block
                                             finish:(void (^)(id responseObject,NSString *error))finish;
/**
 *  发起下载请求并回调下载地址
 *
 *  @param append 本地文件存在时,YES则继续写入,NO则覆盖文件
 *  @param block  下载进度回调
 *  @param finish 下载完成回调
 *
 *  @return 创建的网络请求Operation,供后续操作
 */
-(NSURLSessionDataTask *)download:(void (^)(NSString *downloadPath,NSString *error))finish;
-(NSURLSessionDataTask *)download:(void (^)(NSString *downloadPath,NSString *error))finish
                             append:(BOOL)append;
-(NSURLSessionDataTask *)downloadWithProcess:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))processBlock
                                        finish:(void (^)(NSString *downloadPath,NSString *error))finish
                                        append:(BOOL)append;
/**
 *  生成完整URL路径,子类可重载本方法自定义URL拼接规则
 *
 *  @return 完整URL路径
 */
-(NSString *)generateURL;

/**
 *  发起带进度的上传请求并回调服务器响应结果
 *
 *  @param block  上传进度回调
 *  @param finish 网络请求完成回调
 *
 *  @return 创建的网络请求Operation,供后续操作
 */
-(NSURLSessionDataTask *)upload:(void (^)(id responseObject,NSString *error))finish;
-(NSURLSessionDataTask *)uploadWithProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block
                                            finish:(void (^)(id responseObject,NSString *error))finish;
/**
 *  批量上传文件
 *
 *  @param progressBlock 上传进度回调
 *  @param finish        请求完成回调
 */
-(void)batchUploadWithProgressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                             finish:(void (^)(NSArray *operations,NSString *error))finish;

@end
