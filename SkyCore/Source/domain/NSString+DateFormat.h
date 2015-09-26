//
//  NSString+DateFormat.h
//  wisdomWeather-iPhone
//
//  Created by sky on 14-8-11.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DateFormat)
/**
 *  将格式化的日期字符串重新格式化
 *
 *  @param fromFormat 原来的日期格式化样式
 *  @param toFormat   重新格式化样式
 *
 *  @return 重新格式化后的字符串
 */
-(NSString *)stringFromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;
/**
 *  将日期按样式格式化成字符串
 *
 *  @param date   需要格式化的日期
 *  @param format 格式化样式
 *
 *  @return 格式化后的日期字符串
 */
+(NSString *)stringFromDateWithFormat:(NSString *)format;
+(NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;

@end
