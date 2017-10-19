//
//  SCApplicationInfo.h
//  SkyCore
//
//  Created by sky on 2017/10/13.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCApplication : NSObject

@property (class, readonly, strong) NSDictionary *infoDictionary;
@property (class, readonly, strong) NSString *CTCarrier;
@property (class, readonly, strong) NSString *networkType; // WWAN/WIFI
@property (class, readonly) BOOL isJ_a_ilB_reak;

// Application Description
@property (class, readonly, strong) NSString *bundleIdentifier;
@property (class, readonly, strong) NSString *version;
@property (class, readonly, strong) NSString *buildNumber;
@property (class, readonly, strong) NSString *displayName;
@property (class, readonly, strong) NSString *distributionChannel;
@property (class, readonly, strong) NSString *protocolVersion;
@property (class, readonly, strong) NSString *resolutionString;
@property (nonatomic, readonly, strong) UIImage *appIcon;

// 本app的下载链接
@property (nonatomic, readonly, strong) NSURL *appStoreURL;
@property (nonatomic, readonly, strong) NSURL *appStoreStarURL;
@property (nonatomic, readonly, strong) NSURL *appOfficialURL; // 官方APP链接

@end

@interface UIApplication (SCNavigation)

@property (nonatomic, strong, readonly) __kindof UIViewController *rootViewController;
@property (nonatomic, strong, readonly) UITabBarController *mainTabbarController;
@property (nonatomic, strong, readonly) UINavigationController *currentNavigationController;

- (void)sc_pushViewController:(UIViewController *)controller
                     animated:(BOOL)animated;

- (void)sc_presentViewController:(UIViewController *)controller
                        animated:(BOOL)animated
                      completion:(void (^)(void))completion;

@end


