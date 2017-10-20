//
//  MZResponseListParser.m
//  Meixue
//
//  Created by 郑志勤 on 16/10/20.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZResponseListParser.h"
#import "MZErrorCode.h"
#import "MZListResponse.h"

@interface MZResponseListParser()
@property (nonatomic, weak) MZListResponse *response;

@end

@implementation MZResponseListParser
@dynamic response;

- (NSError *)parseForItemClass:(Class)clazz {
    NSError *error = [super parseForItemClass:clazz];
    if (error) {
        return error;
    }
    
    NSDictionary *responseDictionary = self.response.jsonObject;
    if (!responseDictionary) {
        return [NSError mz_commonLocalSystemErrorWithCode:MZErrorLocalResponseJsonInvalid];
    }

    id object = [responseDictionary valueForKeyPath:@"result"];
    if (!object || (![object isKindOfClass:[NSArray class]] && ![object isKindOfClass:[NSDictionary class]])) {
        return nil;
    }
    MZListEntity *entity = [MZListEntity new];
    
    if ([object isKindOfClass:[NSArray class]]) {
        entity.list = [NSArray yy_modelArrayWithClass:clazz json:object];
    }else if ([object isKindOfClass:[NSDictionary class]]) {
        entity.list = [NSArray yy_modelArrayWithClass:clazz json:object[@"list"]];
        if ([object[@"total"] isKindOfClass:[NSNumber class]]) {
            entity.total = [object[@"total"] integerValue];
        }
        if ([object[@"hasNext"] isKindOfClass:[NSNumber class]]) {
            entity.hasNext = [object[@"hasNext"] boolValue];
        }
//        if (object[@"pvid"]) {
//            entity.pvid = object[@"pvid"];
//        }
//        if (object[@"abtest"]) {
//            entity.abtest = object[@"abtest"];
//        }
    }
    self.response.listEntity = entity;
    return nil;
}

@end
