//
//  NSDate+ChineseCalendar.h
//  wisdomWeather-iPhone
//
//  Created by sky on 14-5-28.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, ChineseCalendarOptions) {
    ChineseCalendarOptionTianGanDiZhi   =   1   <<  0,  //天干地支
    ChineseCalendarOptionShuXiang       =   1   <<  1,  //属相
    ChineseCalendarOptionMonth          =   1   <<  2,  //农历月
    ChineseCalendarOptionDay            =   1   <<  3,  //农历日
};

@interface NSDate (ChineseCalendar)
/**
 *  将日期转换成农历
 *
 *  @param date 日期
 *  @param options 需要显示的选项
 *
 *  @return 农历
 */
+(NSString *)chineseCalendarWithDate:(NSDate *)date;
+(NSString *)chineseCalendarWithDate:(NSDate *)date options:(ChineseCalendarOptions)options;
-(NSString *)toChineseCalendar;
-(NSString *)toChineseCalendarWithOptions:(ChineseCalendarOptions)options;



@end
