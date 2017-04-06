//
//  MyVC.m
//  导航控制器
//
//  Created by ld on 16/9/19.
//  Copyright © 2016年 ld. All rights reserved.
//

#import "PushedVC.h"
#import "HRObject.h"
#import "VIPCenterModel.h"

@interface PushedVC ()

@end

@implementation PushedVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self netRequest];
}
//示范一个网络请求
-(void)netRequest
{
    [HRHTTPTool text:kTextTaskDescription dataClass:[VIPCenterModel class] success:^(HRHTTPModel *responseObject) {
        HRLog(@"成功");
    } failure:^(HRHTTPModel *responseObject) {
    }];
    [HRHTTPTool text:@"请求1" dataClass:[VIPCenterModel class] success:^(HRHTTPModel *responseObject) {
        HRLog(@"成功");
    } failure:^(HRHTTPModel *responseObject) {
    }];
    [HRHTTPTool text:@"请求2" dataClass:[VIPCenterModel class] success:^(HRHTTPModel *responseObject) {
        HRLog(@"成功");
    } failure:^(HRHTTPModel *responseObject) {
    }];
}
@end
