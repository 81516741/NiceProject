//
//  HRWChatApiManager.m
//  NiceProject
//
//  Created by ld on 16/10/31.
//  Copyright © 2016年 ld. All rights reserved.
//

#import "HRWChatApiManager.h"
#import "HRObject.h"
#include "HRConst.h"
@implementation HRWChatApiManager

+(instancetype)share
{
    static HRWChatApiManager * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HRWChatApiManager alloc]init];
    });
    return _instance;
}

+(void)registerApp
{
    [WXApi registerApp:kWChatAppID withDescription:@"demo 2.0"];
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    [WXApi registerAppSupportContentFlag:typeFlag];
}

#pragma  mark - 微信登录
+(void)wchatLogin
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
    req.state = @"123" ;

    //第三方向微信终端发送一个SendAuthReq消息结构
    BOOL isOK = [WXApi sendReq:req];
    if (isOK) {
        HRLog(@"发送成功");
    }else{
        HRLog(@"发送失败");
    }
}

-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp * authResp = (SendAuthResp *)resp;
        HRLog(@"%@",authResp);
    }
}

#pragma mark - 微信分享
+(void)WChatShare:(WChatShareType)type title:(NSString *)title des:(NSString *)des image:(id)image url:(NSString *)url success:(void(^)())success failure:(void(^)(NSString * message))failure
{
    //为什么是反的，搞不懂
    if([WXApi isWXAppInstalled]){
       failure(@"请安装微信客户端");
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    [message setThumbImage:image];
    
    WXWebpageObject *imageObj = [WXWebpageObject object];
    imageObj.webpageUrl = url;
    message.mediaObject = imageObj;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = type;
    BOOL isSuccess = [WXApi sendReq:req];
    if (!isSuccess) {
        failure(@"分享失败");
    }else{
        success();
    }
    
}

@end
