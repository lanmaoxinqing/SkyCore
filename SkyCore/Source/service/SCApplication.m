//
//  SCApplicationInfo.m
//  SkyCore
//
//  Created by sky on 2017/10/13.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import "SCApplication.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "NSArray+SCUtils.h"

@implementation SCApplication

+ (NSDictionary *)infoDictionary __attribute__((const))
{
    return [NSBundle bundleForClass:[SCApplication class]].infoDictionary;
}

//MARK:- info
+ (NSString *)bundleIdentifier __attribute__((const))
{
    return self.infoDictionary[@"CFBundleIdentifier"];
}

+ (NSString *)version __attribute__((const))
{
    return self.infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)buildNumber __attribute__((const))
{
    return self.infoDictionary[@"CFBundleVersion"];
}

+ (NSString *)displayName __attribute__((const))
{
    return self.infoDictionary[@"CFBundleDisplayName"];
}

+ (NSString *)distributionChannel __attribute__((const))
{
    return self.infoDictionary[@"AppChannel"];
}

+ (NSString *)protocolVersion __attribute__((const))
{
    return self.infoDictionary[@"MZProtocolVersion"];
}

+ (NSString *)resolutionString __attribute__((const))
{
    return [NSString stringWithFormat:@"%dx%d", (int)[UIScreen mainScreen].nativeBounds.size.width, (int)[UIScreen mainScreen].nativeBounds.size.height];
}

+ (NSString *)CTCarrier __attribute__((const))
{
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    return carrier.carrierName ?: @"Unknown";
}

+ (BOOL)isJ_a_ilB_reak __attribute__((const))
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]) {
        NSLog(@"The device is jail broken!");
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

+ (NSString *)networkType
{
    NSString *networkTypeString = @"Unknown";
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
            networkTypeString = @"WWAN";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            networkTypeString = @"WIFI";
            break;
        default:
            break;
    }
    return networkTypeString;
}

+ (NSString *)launchImageName
{
    /*
     LaunchImage-568h@2x.png
     LaunchImage-700-568h@2x.png
     LaunchImage-700-Landscape@2x~ipad.png
     LaunchImage-700-Landscape~ipad.png
     LaunchImage-700-Portrait@2x~ipad.png
     LaunchImage-700-Portrait~ipad.png
     LaunchImage-700@2x.png
     LaunchImage-Landscape@2x~ipad.png
     LaunchImage-Landscape~ipad.png
     LaunchImage-Portrait@2x~ipad.png
     LaunchImage-Portrait~ipad.png
     LaunchImage.png
     LaunchImage@2x.png
     
     LaunchImage-800-667h@2x.png (iPhone 6)
     LaunchImage-800-Portrait-736h@3x.png (iPhone 6 Plus Portrait)
     LaunchImage-800-Landscape-736h@3x.png (iPhone 6 Plus Landscape)
     */
    //    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    //    return appInfo[@"UILaunchImages"];
    NSDictionary *dict = @{@"320x480" : @"LaunchImage-700",
                           @"320x568" : @"LaunchImage-700-568h",
                           @"375x667" : @"LaunchImage-800-667h",
                           @"414x736" : @"LaunchImage-800-Portrait-736h"};
    NSString *key = [NSString stringWithFormat:@"%dx%d", (int)[UIScreen mainScreen].bounds.size.width, (int)[UIScreen mainScreen].bounds.size.height];
    return dict[key] ?: dict[@"414x736"];
}

-(UIImage *)appIcon
{
    NSString *iconName = @"AppIcon60x60";
    
    NSDictionary *icons = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIcons"];
    iconName = [icons valueForKeyPath:@"CFBundlePrimaryIcon.CFBundleIconFiles.@lastObject"] ?: iconName;
    return [UIImage imageNamed:iconName];
}

//MARK:- appstore
- (NSURL *)appStoreURL
{
    return [NSURL URLWithString:@"https://itunes.apple.com/cn/app/wang-yi-mei-xue/id1147533466?l=zh&ls=1&mt=8"];
}

- (NSURL *)appStoreStarURL {
    return [NSURL URLWithString:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1147533466&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
}

- (NSURL *)appOfficialURL
{
    return [NSURL URLWithString:@"http://mei.163.com/download"];
}

@end

@implementation UIApplication (SCNavigation)

- (UIViewController *)rootViewController {
    return self.delegate.window.rootViewController;
}

- (UITabBarController *)mainTabbarController {
    if ([self.rootViewController isKindOfClass:[UITabBarController class]]) {
        return self.rootViewController;
    }
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = self.rootViewController;
        __block UITabBarController *tab = nil;
        [nav.viewControllers sc_any:^BOOL(__kindof UIViewController *obj) {
            if ([obj isKindOfClass:[UITabBarController class]]) {
                tab = obj;
                return YES;
            }
            return NO;
        }];
        return tab;
    }
    return nil;
}

- (UINavigationController *)currentNavigationController {
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        return self.rootViewController;
    }
    else if ([self.rootViewController isKindOfClass:[UITableViewController class]]) {
        UITabBarController *tab = self.rootViewController;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            return tab.selectedViewController;
        }
    }
    return nil;
}

- (void)sc_pushViewController:(UIViewController *)controller
                     animated:(BOOL)animated
{
    [self.currentNavigationController pushViewController:controller
                                                animated:animated];
}

- (void)sc_presentViewController:(UIViewController *)controller
                        animated:(BOOL)flag
                      completion:(void (^)(void))completion
{
    [self.currentNavigationController.visibleViewController presentViewController:controller
                                                                         animated:flag
                                                                       completion:completion];
}

@end
