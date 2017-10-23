//
//  MZRequestQueue.h
//  meizhuang
//
//  Created by hzduanjiashun on 16/8/29.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZBaseRequest.h"

@interface MZRequestQueue : NSObject

- (void)addRequest:(MZBaseRequest *)req;

@end
