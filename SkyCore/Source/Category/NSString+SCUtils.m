//
//  NSString+SCUtils.m
//  SkyCore
//
//  Created by sky on 2017/10/14.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import "NSString+SCUtils.h"
#import "NSArray+SCUtils.h"

@implementation NSString (SCUtils)
@end

@implementation NSString (SCBlankFilter)

-(NSString *)stringByDeletingBlank{
    NSString *str=[self stringByReplacingOccurrencesOfString:@" " withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"    " withString:@""];
    return str;
}

-(NSString *)stringbyTrimmingBlank{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"     "]];
}

-(NSString *)stringByMergeBlank{
    NSMutableString *resultStr=[self mutableCopy];
    BOOL isFind = NO;
    for(NSInteger i=[self length]-1;i>=0;i--){
        unichar c=[self characterAtIndex:i];
        //找到空格或tab制表符,统一替换为空格
        if(!isFind && (c==' ' || c=='    ')){
            [resultStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@" "];
            isFind=YES;
        }
        //连续找到空格或tab制表符,删除
        else if(isFind && (c==' ' || c=='    ')){
            [resultStr deleteCharactersInRange:NSMakeRange(i, 1)];
        }
        //重置状态
        else{
            isFind=NO;
        }
        //        if(c==' ' || c=='    '){
        //            if(isFind){//多个空格，删除
        //            }else{//第一个空格或Tab，统一替换为空格
        //            }
        //        }else{//其他字符，重置搜索状态
        //            isFind=NO;
        //        }
    }
    return resultStr;
}

-(NSArray *)componentsSeparatedByBlank{
    //合并空格
    NSString *str=[self stringByMergeBlank];
    //删除多余空格
    str=[str stringbyTrimmingBlank];
    //分割
    return [str componentsSeparatedByString:@" "];
}

- (NSString *)sc_stringByMergeContinuousWhiteSpaceAndNewline __attribute__((const))
{
    NSString *mergedString = [[[self componentsSeparatedByString:@" "] sc_filter:^BOOL(NSString *obj) {
        return [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0;
    }] componentsJoinedByString:@" "];
    
    mergedString = [[[mergedString componentsSeparatedByString:@"\n"] sc_filter:^BOOL(NSString *obj) {
        return [obj stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]].length > 0;
    }] componentsJoinedByString:@"\n"];
    return mergedString;
}

- (NSString *)sc_stringByMergeContinuousNewline __attribute__((const))
{
    NSString *mergedString = [[[self componentsSeparatedByString:@"\n"] sc_filter:^BOOL(NSString *obj) {
        return [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0;
    }] componentsJoinedByString:@"\n"];
    return mergedString;
}

- (NSString *)sc_stringByMergeContinuousWhiteSpaceOrNewline __attribute__((const))
{
    return [[[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sc_filter:^BOOL(NSString *obj) {
        return [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0;
    }] componentsJoinedByString:@" "];
}

- (NSString *)sc_trim __attribute__((const))
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

