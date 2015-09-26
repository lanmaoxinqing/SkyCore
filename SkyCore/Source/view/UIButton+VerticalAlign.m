//
//  UIButton+VerticalAlign.m
//  SkyCore
//
//  Created by sky on 14-9-28.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "UIButton+VerticalAlign.h"

@implementation UIButton (VerticalAlign)

-(void)valign{
    [self valignByPadding:0];
}

-(void)valignByPadding:(CGFloat)padding{
    float imgHeight=self.imageView.frame.size.height;
    float imgWidth=self.imageView.frame.size.width;
    float titleHeight=self.titleLabel.frame.size.height;
    float titleWidth=self.titleLabel.frame.size.width;
    [self setImageEdgeInsets:UIEdgeInsetsMake(-titleHeight,0,0,-titleWidth)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, -imgHeight-padding, 0)];
}

@end
