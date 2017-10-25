//
//  UIWebView+JSCore.h
//  jsbridgeTest
//
//  Created by 心情 on 2017/10/24.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol SCWebViewDelegate <UIWebViewDelegate>

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx;

@end

@interface UIWebView (SCJavaScriptCore)
@property (nonatomic, readonly) JSContext *sc_jsContext;

- (void)sc_didCreateJavascriptContext:(JSContext *)context;

@end
