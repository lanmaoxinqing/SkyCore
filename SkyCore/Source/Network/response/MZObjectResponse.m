//
//  MZObjectResponse.m
//  Meixue
//
//  Created by 郑志勤 on 16/10/20.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZObjectResponse.h"
#import "MZResponseObjectParser.h"

@implementation MZObjectResponse

- (NSError *)parseForEntityName:(NSString *)entityName entityClass:(Class)clazz
{
    if (self.parser == nil) {
        self.parser = [[MZResponseObjectParser alloc] initWithResponse:self];
    }
    NSError *error = [self.parser parseForItemClass:clazz];
    if (error) {
        return error;
    }
    if (entityName.length && self.resultEntity) {
        [self setValue:self.resultEntity forKeyPath:entityName];
    }
    return nil;
}

@end
