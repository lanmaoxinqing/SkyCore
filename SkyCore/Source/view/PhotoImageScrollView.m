//
//  PhotoImageScrollView.m
//  leziyou-iphone
//
//  Created by user on 11-12-14.
//  Copyright 2011年 teemax. All rights reserved.
//

#import "PhotoImageScrollView.h"
#import "UIKit+AFNetworking.h"
#import "SCSysconfig.h"
#import <QuartzCore/QuartzCore.h>

#define EGOPV_ZOOM_SCALE 2.5
@implementation PhotoImageScrollView
@synthesize index,fillMode;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        [self prepare];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator =NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate =self;
        [self prepare];
    }
    return self;
}

-(id)initWithDelegate:(id)adelegate{
    self = [super init];
    if (self) {
        [self prepare];
        delegate = adelegate;
    }
    return self;
}

-(void)prepare{
    UITapGestureRecognizer *single=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    single.numberOfTapsRequired=1;//点击数
    single.numberOfTouchesRequired=1;//接触手指的数量
    [self addGestureRecognizer:single];
    
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTouchesRequired=1;
    doubleTap.numberOfTapsRequired=2;
    [single requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator =NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate =self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    imageView.frame = frameToCenter;
}

-(void)setImageFrame{
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    float imgW = imageView.image.size.width;
    float imgH = imageView.image.size.height;
    float a = imgW/320.0;
    float b = imgH/460.0;
    if (a>b) {
        frameToCenter.size.width = 320.0;
        frameToCenter.size.height = imgH/a;
    }else{
        frameToCenter.size.width = imgW/b;
        frameToCenter.size.height = 460.0;
    }

    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;

    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;

}

-(void)displayImage:(UIImage *)image picTitle:(NSString *)title{
    //添加图片视图
    [imageView removeFromSuperview];
    imageView.clipsToBounds=YES;
    imageView = [[UIImageView alloc]initWithImage:image];
    imageView.layer.cornerRadius=5;
    imageView.layer.shadowOffset=CGSizeMake(2, 2);
    imageView.layer.shadowOpacity=.6;
    
    imageView.layer.shadowColor=[UIColor blackColor].CGColor;
    
    [self setImageFrame];
    [self addSubview:imageView];
    //添加图片标题
    if (imageDesLabel==nil) {
        imageDesLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 50, 200, 50)];
    }
    [imageDesLabel setTextAlignment:NSTextAlignmentCenter];
    [imageDesLabel setText:title];
    [imageDesLabel setBackgroundColor:[UIColor clearColor]];
    [imageDesLabel setTextColor:[UIColor whiteColor]];
    [imageDesLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:imageDesLabel];
    self.contentSize = imageView.frame.size;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

-(void)displayImageByPath:(NSString *)imagePath picTitle:(NSString *)title{
    //添加图片视图
    [imageView removeFromSuperview];
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode=self.contentMode;
    if([imagePath hasPrefix:@"http://"]){
        [imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"img_none"]];
//        [imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"img_none"] options:SDWebImageProgressiveDownload];
       
    }else{
        imageView.image=[UIImage imageWithContentsOfFile:imagePath];
    }
    NSLog(@"%f", imageView.image.size.height);
    NSLog(@"%f", imageView.frame.size.height);
    [self addSubview:imageView];
    //添加图片标题
    if (imageDesLabel==nil) {
        imageDesLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 50, 200, 50)];
    }
    [imageDesLabel setTextAlignment:NSTextAlignmentCenter];
    [imageDesLabel setText:title];
    [imageDesLabel setBackgroundColor:[UIColor clearColor]];
    [imageDesLabel setTextColor:[UIColor whiteColor]];
    [imageDesLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:imageDesLabel];
    self.contentSize = imageView.frame.size;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

-(void)setOrientationZoomScales{
    CGFloat minScale = 1.0;
    CGFloat maxScale = 5.0 / [[UIScreen mainScreen] scale];
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

-(void)setMaxMinZoomScalesForCurrentBounds{
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = imageView.bounds.size;
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);
   // CGFloat minScale = 1.0;
    // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 10.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    NSLog(@"%f, %f", maxScale, minScale);

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}


//界面旋转调用方法
- (CGPoint)pointToCenterAfterRotation
{
    NSLog(@"pointToCenterAfterRotation........");
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:imageView];
}

// returns the zoom scale to attempt to restore after rotation. 
- (CGFloat)scaleToRestoreAfterRotation
{
    NSLog(@"scaleToRestoreAfterRotation.........");
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (contentScale <= self.minimumZoomScale + FLT_EPSILON)
        contentScale = 0;
    
    return contentScale;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale
{    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:imageView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0, 
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    self.contentOffset = offset;
}

-(void)viewZoomBack{
    if (!self.zoomScale > 1.0f) return;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    self.zoomScale = lastZs;
	[UIView commitAnimations];

}

//touch方法
//双击的方法
- (void)zoomRectWithCenter:(CGPoint)center{
    CGRect rect;
    if(self.zoomScale==self.minimumZoomScale){
        rect.size = CGSizeMake(self.frame.size.width / EGOPV_ZOOM_SCALE, self.frame.size.height / EGOPV_ZOOM_SCALE);
        rect.origin.x = MAX((center.x - (rect.size.width / 2.0f)), 0.0f);
        rect.origin.y = MAX((center.y - (rect.size.height / 2.0f)), 0.0f);
    }
    else{
        rect.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        rect.origin.x = MAX((center.x - (rect.size.width / 2.0f)), 0.0f);
        rect.origin.y = MAX((center.y - (rect.size.height / 2.0f)), 0.0f);
    }
     [self zoomToRect:rect animated:YES];//rect表示需要缩放的区域
}


-(void)singleTap{
    if(delegate !=nil && [ delegate respondsToSelector:@selector(PhotoImageScrollViewDidClicked:)]){
        [delegate PhotoImageScrollViewDidClicked:self];
    }
}

-(void)doubleTap:(UITapGestureRecognizer *)tap{
    [self zoomRectWithCenter:[tap locationInView:tap.view]];
}

@end
