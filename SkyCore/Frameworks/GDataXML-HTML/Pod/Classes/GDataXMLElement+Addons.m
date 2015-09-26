//
//  GDataXMLElement+Addons.m
//  wisdomWeather-iPhone
//
//  Created by sky on 14-9-1.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "GDataXMLElement+Addons.h"

@implementation GDataXMLElement (Addons)

-(NSString *)stringForKey:(NSString *)name{
    NSArray *eles=[self elementsForName:name];
    if([eles isNotEmpty]){
        return [[self elementsForName:name][0] stringValue];
    }
    return nil;
}

-(NSInteger)integerForKey:(NSString *)name{
    NSArray *eles=[self elementsForName:name];
    if([eles isNotEmpty]){
        return [[[self elementsForName:name][0] stringValue] integerValue];
    }
    return 0;

}

-(float)floatForKey:(NSString *)name{
    NSArray *eles=[self elementsForName:name];
    if([eles isNotEmpty]){
        return [[[self elementsForName:name][0] stringValue] floatValue];
    }
    return 0.0;

}

-(double)doubleForKey:(NSString *)name{
    NSArray *eles=[self elementsForName:name];
    if([eles isNotEmpty]){
        return [[[self elementsForName:name][0] stringValue] doubleValue];
    }
    return 0.0;
}

@end
