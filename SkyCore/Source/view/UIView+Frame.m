//
//  UIView+Frame.m
//  SkyCore
//
//  Created by sky on 14-9-1.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

-(void)setOriginx:(CGFloat)x{
    CGRect rect=self.frame;
    rect.origin.x=x;
    self.frame=rect;
}

-(void)setOriginy:(CGFloat)y{
    CGRect rect=self.frame;
    rect.origin.y=y;
    self.frame=rect;
}

-(void)setWidth:(CGFloat)width{
    CGRect rect=self.frame;
    rect.size.width=width;
    self.frame=rect;
}

-(void)setHeight:(CGFloat)height{
    CGRect rect=self.frame;
    rect.size.height=height;
    self.frame=rect;
}

-(void)setSize:(CGSize)size{
    CGRect rect=self.frame;
    rect.size=size;
    self.frame=rect;
}

-(void)setOrigin:(CGPoint)point{
    CGRect rect=self.frame;
    rect.origin=point;
    self.frame=rect;
}

-(CGFloat)originx{
    return self.frame.origin.x;
}

-(CGFloat)originy{
    return self.frame.origin.y;
}

-(CGFloat)width{
    return self.frame.size.width;
}
-(CGFloat)height{
    return self.frame.size.height;
}

-(CGSize)size{
    return self.frame.size;
}

-(CGPoint)origin{
    return self.frame.origin;
}

@end
