//
//  CommonTools.h
//  baseFrame-v2
//
//  Created by sky on 13-5-30.
//  Copyright (c) 2013年 teemax. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ValidTypeEmail          =1,//邮箱
    ValidTypeQQ             =2,//qq
    ValidTypeMobile         =3,//手机
    ValidTypeChinese        =4,//中文
    ValidTypeIDCard         =5,//身份证
    
}ValidType;

@interface SCCommonTools : NSObject

#pragma mark - 消息异常处理
+(void)setExceptionHandler;
+(NSUncaughtExceptionHandler *)getExceptionHandler;
+(void)saveAsText:(NSString *)exceptionText;
+(void)sendEmail:(NSString *)exceptionText;

#pragma mark - 验证
/**
 *  信息验证
 *
 *  @param str  需要验证的字符串
 *  @param type 验证类型,具体参考`ValidType`
 *
 *  @return 验证结果
 */
+(BOOL)validateCheck:(NSString *)str stringType:(ValidType)type;

#pragma mark - 16进制颜色转换
+(UIColor *)colorWithHex:(NSString *)hexColor;

/**
 主线程延时操作
 @param delay   延时时间(秒)
 @param ^block  需要延时操作的代码块
 */
void RunBlockAfterDelay(NSTimeInterval delay, void (^block)(void));

@end
