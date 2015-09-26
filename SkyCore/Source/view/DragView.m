//
//  DragView.m
//  sky-core
//
//  Created by sky on 13-9-24.
//  Copyright (c) 2013年 sky. All rights reserved.
//

#import "DragView.h"

@implementation DragView

@synthesize dragEnable;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        dragEnable=YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        dragEnable=YES;
    }
    return self;
}

-(id)init{
    if(self=[super init]){
        dragEnable=YES;
    }
    return self;
}

-(void)awakeFromNib{
    dragEnable=YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    beginPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    moved=YES;
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:self];
    //手势移动,调整视图中心位置
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    CGRect rect = [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds;
    //限制中心点最大最小坐标,防止视图超出屏幕
    CGFloat x=MIN(self.center.x + offsetX, rect.size.width-self.frame.size.width/2);
    x=MAX(x, self.frame.size.width/2);
    CGFloat y=MIN(self.center.y + offsetY, rect.size.height-self.frame.size.height/2);
    y=MAX(y, self.frame.size.height/2);
    self.center = CGPointMake(x,y);
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!moved){
        [super touchesEnded:touches withEvent:event];
    }
    moved=NO;
}

@end
