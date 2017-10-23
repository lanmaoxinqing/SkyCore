//
//  MZPropertyResponse.m
//  Meixue
//
//  Created by sky on 16/10/31.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZPropertyResponse.h"
#import "MZResponsePropertyParser.h"

@implementation MZPropertyResponse

- (NSError *)parseForEntityName:(NSString *)entityName entityClass:(Class)clazz {
    if (self.parser == nil) {
        self.parser = [[MZResponsePropertyParser alloc] initWithResponse:self];
    }
    NSError *error = [self.parser parseForItemClass:clazz];
    if (error) {
        return error;
    }
    return nil;
}

@end
