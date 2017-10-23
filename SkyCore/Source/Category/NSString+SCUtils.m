//
//  NSString+SCUtils.m
//  SkyCore
//
//  Created by sky on 2017/10/14.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import "NSString+SCUtils.h"
#import "NSArray+SCUtils.h"

@implementation NSString (SCBlankFilter)

- (NSString *)sc_stringByMergeContinuousWhiteSpaceAndNewline __attribute__((const))
{
    NSString *mergedString = [[[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] sc_filter:^BOOL(NSString *obj) {
        return [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0;
    }] componentsJoinedByString:@" "];
    
    mergedString = [[[mergedString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] sc_filter:^BOOL(NSString *obj) {
        return [obj stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]].length > 0;
    }] componentsJoinedByString:@"\n"];
    return mergedString;
}

- (NSString *)sc_stringByMergeContinuousNewline __attribute__((const))
{
    NSString *mergedString = [[[self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] sc_filter:^BOOL(NSString *obj) {
        return [obj stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]].length > 0;
    }] componentsJoinedByString:@"\n"];
    return mergedString;
}

- (NSString *)sc_stringByMergeContinuousWhiteSpaceOrNewline __attribute__((const))
{
    return [[[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sc_filter:^BOOL(NSString *obj) {
        return [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0;
    }] componentsJoinedByString:@" "];
}

- (NSString *)sc_trimWhitespaceAndNewline __attribute__((const))
{
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)sc_stringByRemovingHTMLTags __attribute__((const))
{
    NSMutableString *str = [self mutableCopy];
    [str replaceOccurrencesOfString:@"<[^>]+>"
                         withString:@""
                            options:NSRegularExpressionSearch | NSCaseInsensitiveSearch
                              range:NSMakeRange(0, self.length)];
    return [NSString stringWithString:str];
}

@end

//MARK:- 拼音
@implementation NSString (SCChineseLetters)

- (NSString *)firstLetter {
    return [NSString firstLetterOfString:self];
}

- (NSString *)firstLetterForCharactorAtIndex:(NSInteger)index {
    return [NSString firstLetterForCharactorAtIndex:index ofString:self];
}

+ (NSString *)firstLetterOfString:(NSString *)str {
    return [self firstLetterForCharactorAtIndex:0 ofString:str];
}

+ (NSString *)firstLetterForCharactorAtIndex:(NSInteger)index ofString:(NSString *)str {
    if (str.length == 0 || index >= str.length) {
        return @"";
    }
    NSRange range = NSMakeRange(index, 1);
    NSMutableString *aStr = [[str substringWithRange:range] mutableCopy];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)aStr,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)aStr,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [aStr capitalizedString];
    //获取并返回首字母
    if (pinYin.length == 0) {
        return @"";
    }
    return [pinYin substringToIndex:1];
}

- (NSString *)letters {
    if (self.length == 0) {
        return @"";
    }
    NSMutableString *aStr = [self mutableCopy];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)aStr,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)aStr,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    return [aStr uppercaseString];
}

@end

//MARK:- emoji
@implementation NSString (MZEmoji)

- (NSString *)emoji_substringFromIndex:(NSUInteger)from {
    NSRange range = NSMakeRange(from, self.length - from);
    return [self emoji_substringWithRange:range];
}

- (NSString *)emoji_substringWithRange:(NSRange)range {
    NSRange emojiRange = [self rangeOfComposedCharacterSequencesForRange:range];
    return [self substringWithRange:emojiRange];
}

- (NSString *)emoji_substringToIndex:(NSUInteger)to {
    if (to > self.length) {
        to = self.length;
    }
    NSRange range = NSMakeRange(0, to);
    return [self emoji_substringWithRange:range];
}

@end

//MARK:- Secret
@implementation NSString (SCSecret)

- (NSString *)stringByCoverString:(NSString *)cover inRange:(NSRange)range {
    //起点超过长度,不更改
    if (range.location > self.length - 1) {
        return self;
    }
    if (cover.length == 0) {
        cover = @"*";
    }
    range.length = MIN(range.length, self.length - range.location);
    NSMutableString *fixedCover = [NSMutableString string];
    if (cover.length >= range.length) {
        [fixedCover appendString:[cover emoji_substringToIndex:range.length]];
    } else {
        while (fixedCover.length < range.length) {
            [fixedCover appendString:cover];
        }
        fixedCover = [[fixedCover emoji_substringToIndex:range.length] mutableCopy];
    }
    return [self stringByReplacingCharactersInRange:range withString:fixedCover];
}

@end

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

@implementation NSString (IDCard)

- (BOOL)validIDCard {
    NSArray *cityArr = [NSArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],@"北京",@"天津",@"河北",@"山西",@"内蒙古",[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],@"辽宁",@"吉林",@"黑龙江",[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],@"上海",@"江苏",@"浙江",@"安微",@"福建",@"江西",@"山东",[NSNull null],[NSNull null],[NSNull null],@"河南",@"湖北",@"湖南",@"广东",@"广西",@"海南",[NSNull null],[NSNull null],[NSNull null],@"重庆",@"四川",@"贵州",@"云南",@"西藏",[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],@"陕西",@"甘肃",@"青海",@"宁夏",@"新疆",[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],@"台湾",[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],@"香港",@"澳门",[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],@"国外", nil];
    NSArray *wis = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSArray *codes = [NSArray arrayWithObjects:@"1",@"0",@"x",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil];
    NSError *error;
    NSRegularExpression *regex;
    NSTextCheckingResult *result;
    //数字及地址码验证
    regex=[NSRegularExpression regularExpressionWithPattern:@"^(^\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$" options:0 error:&error];
    result=[regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if(!result){
        return NO;
    }
    if([cityArr objectAtIndex:[[self substringWithRange:NSMakeRange(0, 2)] intValue]]==[NSNull null]){
        return NO;
    }
    //日期码验证
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    @try {
        NSString *dateStr=[self substringWithRange:NSMakeRange(6, 8)];
        formatter.dateFormat=@"yyyyMMdd";
        NSDate *date=[formatter dateFromString:dateStr];
        if(!date){
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    //校验码验证
    int sum=0;
    for(int i=0;i<17;i++){
        int ai=[[self substringWithRange:NSMakeRange(i, 1)] intValue];
        int wi=[[wis objectAtIndex:i] intValue];
        sum+=ai*wi;
    }
    NSString *code=[codes objectAtIndex:(sum%11)];
    if(![code isEqualToString:[self substringWithRange:NSMakeRange(17, 1)]]){
        return NO;
    }
    return YES;
}

@end
