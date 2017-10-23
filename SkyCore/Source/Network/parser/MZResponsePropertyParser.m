//
//  MZResponsePropertyParser.m
//  Meixue
//
//  Created by sky on 16/10/31.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZResponsePropertyParser.h"
#import "MZBaseResponse.h"
#import "MZErrorCode.h"

@interface MZResponsePropertyParser()

@property (nonatomic, weak) __kindof MZBaseResponse *response;

@end

@implementation MZResponsePropertyParser
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

    NSDictionary *jsonDictionary = [responseDictionary valueForKeyPath:@"result"];
    if (!jsonDictionary) {
        return nil;
    }
    [self.response yy_modelSetWithDictionary:jsonDictionary];
    return nil;
}


@end
