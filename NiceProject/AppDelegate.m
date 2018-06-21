//
//  AppDelegate.m
//  NiceProject
//
//  Created by ld on 16/9/26.
//  Copyright © 2016年 ld. All rights reserved.
//
#import "AppDelegate.h"
#import "SDWebImageManager.h"
#import "HRDBTool.h"
#import "HRTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [HRTool configRootViewController:_window];
    [HRTool registerThirdShareAndLogin];
    [HRDBTool createAllTable];
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [HRTool shouldOpenUrl:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [HRTool shouldOpenUrl:url];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{    
    SDWebImageManager * mag = [SDWebImageManager sharedManager];
    [mag cancelAll];
    [mag.imageCache clearMemory];
}

@end
