//
//  UIWebView+JSCore.m
//  jsbridgeTest
//
//  Created by 心情 on 2017/10/24.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "UIWebView+JSCore.h"
#import <objc/runtime.h>

static NSHashTable* sc_g_webViews = nil;
static dispatch_once_t sc_webview_js_onceToken;


@implementation UIWebView (SCJavaScriptCore)

+ (void)load {
    Method originInit = class_getInstanceMethod([UIWebView class], @selector(initWithFrame:));
    Method swizzleInit = class_getInstanceMethod([UIWebView class], @selector(sc_initWithFrame:));
    method_exchangeImplementations(originInit, swizzleInit);
    
    Method originInitCoder = class_getInstanceMethod([UIWebView class], @selector(initWithCoder:));
    Method swizzleInitCoder = class_getInstanceMethod([UIWebView class], @selector(sc_initWithCoder:));
    method_exchangeImplementations(originInitCoder, swizzleInitCoder);
    
}

- (instancetype)sc_initWithFrame:(CGRect)frame {
    if ([self sc_initWithFrame:frame]) {
        dispatch_once(&sc_webview_js_onceToken, ^{
            sc_g_webViews = [NSHashTable weakObjectsHashTable];
        });
        [sc_g_webViews addObject:self];
    }
    return self;
}

- (instancetype)sc_initWithCoder:(NSCoder *)aDecoder {
    if ([self sc_initWithCoder:aDecoder]) {
        dispatch_once(&sc_webview_js_onceToken, ^{
            sc_g_webViews = [NSHashTable weakObjectsHashTable];
        });
        [sc_g_webViews addObject:self];
    }
    return self;
}

- (JSContext *)sc_jsContext {
    return objc_getAssociatedObject(self, @selector(sc_jsContext));
}

- (void)sc_didCreateJavascriptContext:(JSContext *)context {
    [self willChangeValueForKey: @"sc_jsContext"];
    objc_setAssociatedObject(self, @selector(sc_jsContext), context, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey: @"sc_jsContext"];
    if ([self.delegate respondsToSelector:@selector(webView:didCreateJavaScriptContext:)]) {
        [(id<SCWebViewDelegate>)self.delegate webView:self didCreateJavaScriptContext:context];
    }
}

@end

@interface NSObject (MZJavaScriptCore)

- (void)webView:(id)unused didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)alsoUnused;

@end

@implementation NSObject (MZJavaScriptCore)

- (void)webView:(id)unused didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)alsoUnused {
    if (!ctx) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIWebView *webview in sc_g_webViews) {
            if (![webview isKindOfClass:[UIWebView class]]) {
                continue;
            }
            NSString *token = [NSString stringWithFormat:@"webview_js_core_token_%zud",webview.hash];
            [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var %@ = '%@'",token, token]];
            if ([ctx[token].toString isEqualToString:token]) {
                [webview sc_didCreateJavascriptContext:ctx];
                break;
            }
        }
    });
}

@end

