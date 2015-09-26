//
//  PhotoImageScrollView.h
//  leziyou-iphone
//
//  Created by user on 11-12-14.
//  Copyright 2011年 teemax. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoImageScrollViewDelegate;

typedef enum {
    PhotoImageScrollViewFillModeScale,      //填充
    PhotoImageScrollViewFillModeAspectMin,  //自适应(完整显示)
    PhotoImageScrollViewFillModeAspectMax,  //自适应(较短边完整显示)
    PhotoImageScrollViewFillModeOrigin,     //原始尺寸
}PhotoImageScrollViewFillMode;

@interface PhotoImageScrollView : UIScrollView <UIScrollViewDelegate> {
    NSUInteger index;
    UIImageView *imageView;
    float lastZs;
    id delegate;
    UILabel *imageDesLabel;
}

@property (nonatomic,assign)NSUInteger index;
@property(nonatomic,assign) PhotoImageScrollViewFillMode fillMode;

-(id)initWithDelegate:(id)adelegate;
-(void)displayImageByPath:(NSString *)imagePath picTitle:(NSString *)title;
-(void)displayImage:(UIImage *)image picTitle:(NSString *)title;
-(void)setMaxMinZoomScalesForCurrentBounds;
-(void)setOrientationZoomScales;
-(CGPoint)pointToCenterAfterRotation;
-(CGFloat)scaleToRestoreAfterRotation;
-(void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;
-(void)setImageFrame;

@end

@protocol PhotoImageScrollViewDelegate <NSObject>
@optional
-(void)PhotoImageScrollViewDidClicked:(PhotoImageScrollView *)photoImageScrollView;

@end
