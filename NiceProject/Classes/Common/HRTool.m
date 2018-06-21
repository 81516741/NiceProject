//
//  HRTool.m
//  NiceProject
//
//  Created by ld on 17/2/13.
//  Copyright © 2017年 ld. All rights reserved.
//

#import "HRTool.h"
#import "HRRootNC.h"
#import "OnboardingViewController.h"
#import "HRWChatApiManager.h"
#import "HRQQApiManager.h"
#import "HRSinaApiManager.h"

#define kVersionKey @"CFBundleVersion"
@implementation HRTool

#pragma mark - 配置window的根控制器
+(void)configRootViewController:(UIWindow *)window
{
    if ([HRTool showIntroductionView]) {
        [self showIntroductionViewController:window];
    }else{
        [self showNormalViewController:window];
    }
    [window makeKeyAndVisible];
}

+ (void)showNormalViewController:(UIWindow *)window
{
    window.rootViewController = [HRRootNC rootNC:@[@"Item1",@"Item2",@"Item3"] centerVCTitles:@[@"首页",@"中间",@"最后"] centerVCImagePres:@[@"first",@"second",@"third"] leftVCName:@"LeftVC"];
    [HRTool updateLocalVersion];
}
+ (void)showIntroductionViewController:(UIWindow *)window
{
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:nil body:nil image:[UIImage imageNamed:@"blue"] buttonText:@"这是你想要的第一个" action:nil];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:nil body:nil image:[UIImage imageNamed:@"red"] buttonText:@"第二个也是不错的" action:nil];
    
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:nil body:nil image:[UIImage imageNamed:@"yellow"] buttonText:@"开启应用" action:^{
        [self showNormalViewController:window];
    }];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"sun" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundVideoURL:movieURL contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.fadePageControlOnLastPage = YES;
    onboardingVC.fadeSkipButtonOnLastPage = YES;
    onboardingVC.allowSkipping = YES;
    [onboardingVC.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    onboardingVC.skipHandler = ^{
        [self showNormalViewController:window];
    };
    window.rootViewController = onboardingVC;
}

#pragma mark - 注册和处理第三方分享和登录
+(void)registerThirdShareAndLogin
{
    [HRWChatApiManager registerApp];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSinaAppKey];
}

+ (BOOL)shouldOpenUrl:(NSURL *)url
{
    NSString *scheme = url.scheme;
    if ([scheme isEqualToString:kWChatAppID]){
        NSRange range = [url.absoluteString rangeOfString:@"pay"];
        if (range.length > 0) { //微信支付
            return YES;
        } else { //微信
            return [WXApi handleOpenURL:url delegate:[ HRWChatApiManager share]];
        }
        
    } else if ([scheme isEqualToString:kQQAppScheme]){
        [QQApiInterface handleOpenURL:url delegate:[HRQQApiManager share]];
        return [TencentOAuth HandleOpenURL:url];
        
    } else if ([scheme isEqualToString:kSinaAppScheme]){
        return [WeiboSDK handleOpenURL:url delegate:[HRSinaApiManager share]];
    }
    return false;
}


#pragma mark - 其他
+(BOOL)showIntroductionView
{
    if ([[self currentVersion] isEqualToString:[self localVersion]]) {
        return NO;
    }else{
        return YES;
    }
}

+(NSString *)currentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:kVersionKey];
    app_build = app_build ? app_build : @"";
    return app_build;
}

+(NSString *)localVersion
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kVersionKey];
}

+(void)updateLocalVersion
{
    [[NSUserDefaults standardUserDefaults]setObject:[self currentVersion] forKey:kVersionKey];
}
@end
