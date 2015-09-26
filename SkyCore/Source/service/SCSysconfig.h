//
//  SysConfig.h
//  baseFrame-v2
//
//  Created by sky on 13-5-30.
//  Copyright (c) 2013年 teemax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAppCache.h"
#import "SCCommonTools.h"

/**配置文件索引*/
#define kBundleKeyVersion       @"CFBundleVersion"  //版本信息
#define kBundleKeyAppleId       @"AppleID"          //软件ID
#define kBundleKeyAPI           @"WebAPI"           //API根路径
#define kBundleKeyDataBase      @"DataFile"         //数据库名
#define kBundleKeyBaiduAppKey   @"BaiduAppKey"      //百度ak

/**下载资源文件根目录*/
#define kRootFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Documents"]
//iPhone5
#define SCIsIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//iPad
#define SCIsIPad (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
//iOS版本
#define SCIsIOSVersion(version) ([[[UIDevice currentDevice] systemVersion] floatValue]>=version)
//iOS7
#define SCIsIOS7 SCIsIOSVersion(7.0)
//UIColor生成
#define kRGBColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kHexColor(hexColor) [SCCommonTools colorWithHex:hexColor]
/*日志打印*/
#if DEBUG
    //simple
    #ifdef SCLogSimple
        #define NSLog(s, ...) printf("%s\n",[[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String])
    #endif
    //detail
    #ifdef SCLogDetail
        #define NSLog(s, ...) NSLog(@"%s(%d) %@",__FUNCTION__, __LINE__,[NSString stringWithFormat:(s), ##__VA_ARGS__])
    #endif
#else
    //product
    #define NSLog(s, ...)

#endif

#define NSLogFrame(view) NSLog(@"%@(%f,%f,%f,%f)",[view class],view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height)
#define NSLogBounds(view) NSLog(@"%@(%f,%f,%f,%f)",[view class],view.bounds.origin.x,view.bounds.origin.y,view.bounds.size.width,view.bounds.size.height)

#define IgnorePerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/**
	系统常量
	@author sky
 */
@interface SCSysconfig : NSObject

#pragma mark - 系统状态
/**
	判断是否连接网络
	@returns 连接状态
 */
+(BOOL)isNetworkReachable;
/**
	判断是否连接wifi
	@returns wifi连接状态
 */
+ (BOOL)isWiFiConnection;
/**
	获取系统当前电池电量
	@returns 电池电量
 */
+(float)currentBatteryLevel;

#pragma mark - 系统常量
/**
	获取7位随机字符串(本次应用运行内唯一)
	@returns 随机字符串
 */
+(NSString *)tokenId;
/**
	获取系统IMSI
	@returns imsi
 */
+(NSString *)imsi;
/**
 应用内文件读取统一方法,根据文件后缀生成文件夹,返回文件路径
	@param fileName 文件名
	@returns 文件路径
 */
+(NSString *)filePathByName:(NSString *)fileName;

#pragma mark - 配置文件数据
/**
	获取配置文件值
	@param bundleKey 参数
	@returns 值
 */
+(NSString *)bundleValueByKey:(NSString *)bundleKey;
/**
	获取数据库路径
	@returns 数据库路径
 */
+(NSString *)databasePath;
/**
	获取系统API根路径(plist中的Web API字段)
	@returns API根路径
 */
+(NSString *)webAPI;
/**
 *  获取百度服务AppKey
 *
 *  @return AppKey
 */
+(NSString *)baiduAppKey;
/**
	获取应用当前版本号
	@returns 版本号
 */
+(NSString *)currentVersion;
/**
 *  获取appstore商店中的应用地址
 *
 *  @return appstore商店中的应用地址
 */
+(NSString *)appStorePath;

@end
