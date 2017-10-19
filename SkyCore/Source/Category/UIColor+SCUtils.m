//
//  UIColor+SCUtils.m
//  SkyCore
//
//  Created by sky on 2017/10/19.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import "UIColor+SCUtils.h"

UIColor *SCHexColor(NSUInteger hex) {
    return [UIColor sc_colorWithHexColor:hex];
}

@implementation UIColor (SCHex)

+ (UIColor *)sc_colorWithHexColor:(NSUInteger)hex __attribute((const)) {
    return [self sc_colorWithHexColor:hex alpha:1.f];
}

+ (UIColor *)sc_colorWithHexColor:(NSUInteger)hex alpha:(CGFloat)alpha __attribute((const))
{
    return [UIColor colorWithRed:((hex >> 16) & 0xff)/255.f
                           green:((hex >> 8) & 0xff)/255.f
                            blue:(hex & 0xff)/255.f
                           alpha:alpha];
}


@end
