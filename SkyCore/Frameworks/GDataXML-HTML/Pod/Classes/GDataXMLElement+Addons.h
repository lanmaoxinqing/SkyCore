//
//  GDataXMLElement+Addons.h
//  wisdomWeather-iPhone
//
//  Created by sky on 14-9-1.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "GDataXMLNode.h"

@interface GDataXMLElement (Addons)

-(NSString *)stringForKey:(NSString *)name;
-(NSInteger)integerForKey:(NSString *)name;
-(float)floatForKey:(NSString *)name;
-(double)doubleForKey:(NSString *)name;

@end
