//
//  MZResponseParser.h
//  Meixue
//
//  Created by 郑志勤 on 16/10/20.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@class MZBaseResponse;
@interface MZResponseParser<ResponseType> : NSObject

@property (nonatomic, weak, readonly) ResponseType response;

+ (instancetype)parserWithResponse:(ResponseType)response;
- (instancetype)initWithResponse:(ResponseType)response;

- (NSError *)parseForItemClass:(Class)clazz;

@end
