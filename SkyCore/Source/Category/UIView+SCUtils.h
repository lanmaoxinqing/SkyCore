//
//  UIView+SCUtils.h
//  SkyCore
//
//  Created by sky on 2017/10/19.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SCFrame)

@property (nonatomic, assign) CGFloat x, y, width, height, centerX, centerY;
@property (nonatomic, assign) CGFloat top, left, right, bottom;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@end

@interface UIView (SCSnapshot)

- (UIImage *)sc_snapshotImage;

@end

@interface UIView (SCCornerRadius)

- (void)sc_setCorners:(UIRectCorner)corners radius:(CGFloat)radius;

@end
