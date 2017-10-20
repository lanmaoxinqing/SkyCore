
//
//  MZResponseParser.m
//  Meixue
//
//  Created by 郑志勤 on 16/10/20.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZResponseParser.h"
#import "MZBaseResponse.h"
#import "MZErrorCode.h"

@interface MZResponseParser()

@property (nonatomic, weak) __kindof MZBaseResponse *response;

@end

@implementation MZResponseParser

+ (instancetype)parserWithResponse:(id)response {
    return [[self alloc] initWithResponse:response];
}

- (instancetype)initWithResponse:(id)response {
    if (self = [super init]) {
        _response = response;
    }
    return self;
}

- (NSError *)parseForItemClass:(Class)clazz {
    NSData *originData = self.response.responseData;
    if (!originData) {
        return [NSError mz_commonLocalSystemErrorWithCode:MZErrorLocalResponseEmpty];
    }
    
    NSDictionary *responseDictionary = self.response.jsonObject;
    if (!responseDictionary) {
        return [NSError mz_commonLocalSystemErrorWithCode:MZErrorLocalResponseJsonInvalid];
    }
    
    //老接口未返回错误码，默认200
    NSInteger code = [responseDictionary[@"code"] integerValue];
    if (code == 0) {
        code = 200;
    }
    self.response.responseCode = [@(code) stringValue];
    
    //优先读取服务器显示字段
    NSString *description = responseDictionary[@"description"];
    if (!description || [description isEqual:[NSNull null]] || description.length == 0) {
        //读取错误信息字段
        description = responseDictionary[@"msg"];
        if (!description || [description isEqual:[NSNull null]] || description.length == 0) {
            //没出错
            if (code == 200) {
                description = @"";
            }
            //未提供提示信息
            else {
                description = @"未知错误";
            }
        }
    }
    self.response.responseMessage = description;

    return nil;
}

@end
