//
//  UIColor+SCUtils.h
//  SkyCore
//
//  Created by sky on 2017/10/19.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN UIColor *SCHexColor(NSUInteger hex);

@interface UIColor (SCHex)

+ (UIColor *)sc_colorWithHexColor:(NSUInteger)hex;
+ (UIColor *)sc_colorWithHexColor:(NSUInteger)hex alpha:(CGFloat)alpha;

@end
