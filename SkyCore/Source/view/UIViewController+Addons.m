//
//  UIViewController+Addons.m
//  hztour-iphone
//
//  Created by liu ding on 12-2-8.
//  Copyright 2012年 teemax. All rights reserved.
//

#import "UIViewController+Addons.h"
#import "SCSysconfig.h"
#import <QuartzCore/QuartzCore.h>
#import "SCAppCache.h"
#import "SCBaseDao.h"
#import "MBProgressHUD.h"

MBProgressHUD *progressHUD;
UILabel *titLabel;

@implementation UIView (Addons)

-(void)showWaitview{
    [self showWaitview:@"正在加载，请稍后..."];
}

-(void)showWaitview:(NSString *)text{
    if(progressHUD==nil){
        progressHUD=[[MBProgressHUD alloc] initWithView:self];
        progressHUD.removeFromSuperViewOnHide=YES;
    }
    [self addSubview:progressHUD];
    progressHUD.mode=MBProgressHUDModeIndeterminate;
    progressHUD.labelText=text;
    [progressHUD show:YES];
    self.userInteractionEnabled = NO;
}

-(void)removeWaitview{
    self.userInteractionEnabled = YES;
    [progressHUD hide:YES];
}

-(void)showSuggestion:(NSString *)info{
    [self showSuggestion:info showTime:1.0];
}

-(void)showSuggestion:(NSString *)info showTime:(float)time{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *progressHUD=[[MBProgressHUD alloc] initWithView:window];
    progressHUD.removeFromSuperViewOnHide=YES;
    [window addSubview:progressHUD];
    progressHUD.mode=MBProgressHUDModeText;
    progressHUD.labelText=info;
    [progressHUD show:YES];
    [progressHUD hide:YES afterDelay:time];
}

-(void)showAlertWithMessage:(NSString *)msg{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end

@implementation UIViewController(Addons)

-(void)showWaitview{
    [self showWaitview:@"正在加载，请稍后..."];
}

-(void)showWaitview:(NSString *)text{
    [self.view showWaitview:text];
}

-(void)removeWaitview{
    [self.view removeWaitview];
}

-(void)doMiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)replaceBgColorWithImage{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    imageView.image=[UIImage imageNamed:@"bg.png"];
    [self.view insertSubview:imageView belowSubview:[self.view.subviews objectAtIndex:0]];
}

-(void)setTitle:(NSString *)title Animated:(BOOL)animate{
    if(!animate){
        self.navigationItem.title=title;
    }else{
        if((NSNull *)title==[NSNull null] || [title length]==0){
            title=@"";
        }
        titLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 0, 146, 44)];
        [titLabel setBackgroundColor:[UIColor clearColor]];
        CGSize titleSize;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        titleSize=[title boundingRectWithSize:CGSizeMake(MAXFLOAT, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]} context:nil].size;
#else
        titleSize = [title sizeWithFont:[UIFont systemFontOfSize:20.0] constrainedToSize:CGSizeMake(MAXFLOAT, 44) lineBreakMode:NSLineBreakByWordWrapping];
#endif
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 146, 44)];
        titleLabel.adjustsFontSizeToFitWidth = NO;
        titleLabel.numberOfLines = 1;
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:20.0]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:title];
        [titLabel addSubview:titleLabel];
        [self.navigationItem setTitleView:titleLabel];
        
        if (titleSize.width>146) {
            CGRect frame = titleLabel.frame;
            frame.origin.x = 146;
            frame.size.width = titleSize.width;
            titleLabel.frame = frame;
            
            [UIView beginAnimations:@"titleAnimation" context:NULL];
            [UIView setAnimationDuration:4.5f];  
            [UIView setAnimationCurve:UIViewAnimationCurveLinear]; 	
            [UIView setAnimationDelegate:self];  
            [UIView setAnimationRepeatAutoreverses:NO];	 
            [UIView setAnimationRepeatCount:999999]; 
            
            frame = titleLabel.frame;
            frame.origin.x = -titleSize.width;
            titleLabel.frame = frame;
            [UIView commitAnimations];
        }
    }
}

-(void)showSuggestion:(NSString *)info{
    [self showSuggestion:info showTime:1.0];
}

-(void)showSuggestion:(NSString *)info showTime:(float)time{
    [self.view showSuggestion:info showTime:time];
}

-(void)showAlertWithMessage:(NSString *)msg{
    [self.view showAlertWithMessage:msg];
}

-(id)createControllerByName:(NSString *)name{
    NSString *className=[NSString stringWithFormat:@"%@Controller",name];
    NSString *xib=[[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    Class cl=NSClassFromString(className);
    if(xib==nil && cl==nil){
        className=[NSString stringWithFormat:@"%@Controller",name];
        xib=[[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
        cl=NSClassFromString(className);
        if(xib==nil && cl==nil){
            NSString *msg=[NSString stringWithFormat:@"%@文件未找到",className];
            [self showAlertWithMessage:msg];
            return nil;
        }
    }
    if(xib!=nil){
        id controller=[[cl alloc] initWithNibName:className bundle:nil];
        return controller;
    }else{
        id controller=[[cl alloc] init];
        return controller;
    }

}

@end