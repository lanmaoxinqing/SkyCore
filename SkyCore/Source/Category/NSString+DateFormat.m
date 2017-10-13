//
//  NSString+DateFormat.m
//  wisdomWeather-iPhone
//
//  Created by sky on 14-8-11.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "NSString+DateFormat.h"

@implementation NSString (DateFormat)

-(NSString *)stringFromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat{
    NSDateFormatter *format=[NSDateFormatter new];
    [format setDateFormat:fromFormat];
    NSDate *date=[format dateFromString:self];
    
    NSDateFormatter *strFormat=[NSDateFormatter new];
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLocale *zh_Locale = [[NSLocale alloc] initWithLocaleIdentifier:preferredLang];
                           [strFormat setLocale:zh_Locale];
    [strFormat setDateFormat:toFormat];
    return [strFormat stringFromDate:date];
}

+(NSString *)stringFromDateWithFormat:(NSString *)format{
    return [self stringFromDate:[NSDate date] withFormat:format];
}

+(NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format{
    NSDateFormatter *dateFormat=[NSDateFormatter new];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

@end
