//
//  MJTouchID.m
//  MJTouchID
//
//  Created by YXCZ on 17/4/25.
//  Copyright © 2017年 林民敬. All rights reserved.
//  http://www.jianshu.com/u/2a2051ad6a5d 我的简书博客

#import "MJTouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation MJTouchID

+ (instancetype)touchID {
    static MJTouchID * touchID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        touchID = [[MJTouchID alloc] init];
    });
    return touchID;
}

-(void)startMJTouchIDWithMessage:(NSString*)message
                   fallBackTitle:(NSString*)fallfallBackTitle
                      BlockState:(StateBlock)block
{
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"系统版本不支持TouchID (必须高于iOS 8.0才能使用)");
            block(MJTouchIDStateVersionNotSupport,nil);
        });
        
        return;
    }
    
    LAContext *context = [[LAContext alloc]init];
    
    context.localizedFallbackTitle = fallfallBackTitle == nil ? MJNotice(@"输入密码", @"Enter Password") :fallfallBackTitle;
    
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:message == nil ? @"通过Home键验证已有指纹":message reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"TouchID 验证成功");
                    block(MJTouchIDStateSuccess,error);
                });
            }else if(error){
                
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 验证失败");
                            block(MJTouchIDStateFail,error);
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被用户手动取消");
                            block(MJTouchIDStateUserCancel,error);
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"用户不使用TouchID,选择手动输入密码");
                            block(MJTouchIDStateInputPassword,error);
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                            block(MJTouchIDStateSystemCancel,error);
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                            block(MJTouchIDStatePasswordNotSet,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                            block(MJTouchIDStateTouchIDNotSet,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无效");
                            block(MJTouchIDStateTouchIDNotAvailable,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,需要用户在设置中重新解锁)");
                            block(MJTouchIDStateTouchIDLockout,error);
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                            block(MJTouchIDStateAppCancel,error);
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                            block(MJTouchIDStateInvalidContext,error);
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前设备不支持TouchID");
            block(MJTouchIDStateNotSupport,error);
        });
        
    }

}

@end
