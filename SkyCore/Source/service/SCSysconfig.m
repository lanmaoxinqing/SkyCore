//
//  SysConfig.m
//  baseFrame-v2
//
//  Created by sky on 13-5-30.
//  Copyright (c) 2013年 teemax. All rights reserved.
//

#import "SCSysconfig.h"
#import "SFHFKeychainUtils.h"
#import "SCFileOper.h"
#include <mach/machine.h>
#import "AFNetworkReachabilityManager.h"

#define kBaiduAppKeyDefault @"b9Dw10Cb6QAVROIP7mT37L9v"

static NSMutableDictionary *cfgDict;
@implementation SCSysconfig

#pragma mark - 系统状态

+(BOOL)isNetworkReachable{
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

+ (BOOL)isWiFiConnection {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}

+(float)currentBatteryLevel{
    UIDevice *device=[UIDevice currentDevice];
    [device setBatteryMonitoringEnabled:YES];//电量告诫
    return device.batteryLevel;
}

#pragma mark - 系统常量
+(NSString *)tokenId{
    NSString *tokenId=[SCAppCache cacheValueForKey:CacheKeyTokenId];
    if(tokenId==nil){
        NSDate* date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHMMSS"];
        int value =1000000+arc4random()%8999999;
        tokenId=[NSString stringWithFormat:@"%@%d",[formatter stringFromDate:date],value];
        [SCAppCache setCacheValue:tokenId forKey:CacheKeyTokenId];
    }
    return tokenId;
}

+(NSString *)imsi{
    NSString *imsi=nil;
    NSError *error=nil;;
    imsi=[SFHFKeychainUtils getPasswordForUsername:@"grassinfo" andServiceName:@"skycore" error:&error];
    if(error){
        NSLog(@"%@",[error description]);
    }else if(imsi==nil){
        imsi=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SFHFKeychainUtils storeUsername:@"grassinfo" andPassword:imsi forServiceName:@"skycore" updateExisting:YES error:&error];
        if(error){
            NSLog(@"%@",[error description]);
        }
    }
    return imsi;
}

+(NSString *)filePathByName:(NSString *)fileName{
    NSString *filePath=nil;
    //分离文件名和后缀
    NSRange range=[fileName rangeOfString:@"." options:NSBackwardsSearch];
    NSString *fileType=@"other";
    NSString *name=fileName;
    if(range.location!=NSNotFound){
        fileType=[fileName substringFromIndex:range.location+1];
        name=[fileName substringToIndex:range.location];
    }
    name = [name stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    name = [name stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *newName=[name stringByAppendingFormat:@".%@",fileType];
    filePath=[kRootFolder stringByAppendingPathComponent:fileType];
    //确保文件夹存在
    [SCFileOper createFolder:filePath];
    filePath=[filePath stringByAppendingPathComponent:newName];
    return filePath;
}

#pragma mark - 配置文件数据

+(NSObject *)bundleValueByKey:(NSString *)key{
    if(cfgDict == nil){
        NSString* File = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        cfgDict = [[NSMutableDictionary alloc] initWithContentsOfFile:File];
    }
    return [cfgDict objectForKey:key];
}

+(NSString *)databasePath{
    NSString *name=[self bundleValueByKey:kBundleKeyDataBase];
    NSAssert(name, @"%@未配置",kBundleKeyDataBase);
    NSString *dataPath=[self filePathByName:name];
    return dataPath;
}

+(NSString *)webAPI{
    NSString *api=[self bundleValueByKey:kBundleKeyAPI];
    NSAssert(api, @"%@未配置",kBundleKeyAPI);
    return api;
}

+(NSString *)baiduAppKey{
    NSString *ak=[self bundleValueByKey:kBundleKeyBaiduAppKey];
    if(![ak sc_isNotEmpty]){
        ak=kBaiduAppKeyDefault;
    }
    NSAssert(ak, @"%@未配置",kBundleKeyAPI);
    return ak;
}

+(NSString *)appStorePath{
    NSString *appleId=[self bundleValueByKey:kBundleKeyAppleId];
    NSAssert(appleId, @"%@未配置",kBundleKeyAppleId);
    if(appleId){
        return [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8",appleId];
    }
    return nil;
}

+(NSString *)currentVersion{
    return (NSString *)[self bundleValueByKey:kBundleKeyVersion];
}

@end
