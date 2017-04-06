//
//  HRTool.h
//  NiceProject
//
//  Created by ld on 17/2/13.
//  Copyright © 2017年 ld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRTool : NSObject
#pragma mark - 配置window的根控制器
+(void)configRootViewController:(UIWindow *)window;

#pragma mark - 注册和处理第三方分享和登录
+(void)registerThirdShareAndLogin;
+ (BOOL)shouldOpenUrl:(NSURL *)url;

/**
 * 当前版本
 */
+(NSString *)currentVersion;
/**
 * 本地保存的版本
 */
+(NSString *)localVersion;
/**
 * 更新本地版本
 */
+(void)updateLocalVersion;
@end
