//
//  HRHTTPTool.m
//
//  Created by ld on 16/9/26.
//  Copyright © 2016年 ld. All rights reserved.
//

#import "HRHTTPTool.h"
#import "HRHTTPModel.h"
#import "HRHTTPManager.h"
#import "HRConst.h"
#import "YYModel.h"
static NSMutableDictionary * taskDescriptions = nil;
@implementation HRHTTPTool

+(void)sendMessage:(HRHTTPModel *)message success:(void (^)(HRHTTPModel *))success failure:(void (^)(HRHTTPModel *))failure
{
    if (taskDescriptions == nil) {
        taskDescriptions = @{}.mutableCopy;
    }
    NSArray *syms = [NSThread  callStackSymbols];
    if ([syms count] > 3) {
        NSString * stackSymbol = [syms objectAtIndex:2];
        NSRange range = [stackSymbol rangeOfString:@"["];
        stackSymbol = [stackSymbol substringFromIndex:range.location + 1];
        NSString * callViewControllerName = [stackSymbol componentsSeparatedByString:@" "][0];
        [taskDescriptions setObject:callViewControllerName forKey:message.taskDescription];
    }
    [[HRHTTPManager shared] sendMessage:message success:success failure:failure];
}

+(void)cancelHTTPTask:(NSString *)taskDescription
{
    [[HRHTTPManager shared] cancelHTTPTask:taskDescription];
}

+(void)cancelHTTPTasksByViewControllerName:(NSString *)viewControllerName
{
    [taskDescriptions enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:viewControllerName]) {
            [HRHTTPTool cancelHTTPTask:key];
            [taskDescriptions removeObjectForKey:key];
        }
    }];
}

+(void)text:(NSString *)taskDescription dataClass:(Class)dataClass success:(void (^)(HRHTTPModel *))success failure:(void (^)(HRHTTPModel *))failure{
    HRHTTPModel * message = [HRHTTPModel new];
    message.httpType = HRHTTPTypeGet;
    message.taskDescription = taskDescription;
    message.url = @"https://api.github.com/users/81516741";
    message.dataClass = dataClass;
    NSMutableDictionary * paramasDic = [NSMutableDictionary dictionary];
    [paramasDic setObject:@"value" forKey:@"key"];
    message.parameters = paramasDic;
    
    //**************真实走下面****************//
    [HRHTTPTool sendMessage:message success:^(HRHTTPModel *model) {
        if ([model.data[@"status"] integerValue] == 0) {
            HRLog(@"获取数据成功");
            //JSON文件的路径
            NSString *path = [[NSBundle mainBundle] pathForResource:@"text.json" ofType:nil];
            //加载JSON文件
            NSData *data = [NSData dataWithContentsOfFile:path];
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            model.data = [dataClass yy_modelWithDictionary:obj];
            if (success) {
                success(model);
            }
        }else{
            HRLog(@"获取数据失败,失败原因\n:%@",model.errorOfMy);
            model.errorOfMy = model.data[@"error"];
            if (failure) {
               failure(model);
            }
        }
        
    } failure:^(HRHTTPModel *model) {
        HRLog(@"获取数据失败,失败原因\n:%@",model.errorOfAFN);
        if (failure) {
            failure(model);
        }
    }];
}

@end
