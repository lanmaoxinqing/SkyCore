//
//  MZResponseObjectParser.m
//  Meixue
//
//  Created by 郑志勤 on 16/10/20.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZResponseObjectParser.h"
#import "MZErrorCode.h"
#import "MZObjectResponse.h"

@interface MZResponseObjectParser()
@property (nonatomic, weak) MZObjectResponse *response;

@end

@implementation MZResponseObjectParser
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
    
    self.response.resultEntity = [clazz yy_modelWithDictionary:jsonDictionary];
    return nil;
}

@end
