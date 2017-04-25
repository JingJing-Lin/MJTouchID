//
//  MJTouchID.h
//  MJTouchID
//
//  Created by YXCZ on 17/4/25.
//  Copyright © 2017年 林民敬. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 中英文切换
 */
#define MJNotice(Chinese,English) [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Hans"] ? Chinese : English

/**
 *  TouchID 状态
 */
typedef NS_ENUM(NSUInteger, MJTouchIDState){
    
    /**
     *  当前设备不支持TouchID
     */
    MJTouchIDStateNotSupport = 0,
    /**
     *  TouchID 验证成功
     */
    MJTouchIDStateSuccess = 1,
    
    /**
     *  TouchID 验证失败
     */
    MJTouchIDStateFail = 2,
    /**
     *  TouchID 被用户手动取消
     */
    MJTouchIDStateUserCancel = 3,
    /**
     *  用户不使用TouchID,选择手动输入密码
     */
    MJTouchIDStateInputPassword = 4,
    /**
     *  TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    MJTouchIDStateSystemCancel = 5,
    /**
     *  TouchID 无法启动,因为用户没有设置密码
     */
    MJTouchIDStatePasswordNotSet = 6,
    /**
     *  TouchID 无法启动,因为用户没有设置TouchID
     */
    MJTouchIDStateTouchIDNotSet = 7,
    /**
     *  TouchID 无效
     */
    MJTouchIDStateTouchIDNotAvailable = 8,
    /**
     *  TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)
     */
    MJTouchIDStateTouchIDLockout = 9,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    MJTouchIDStateAppCancel = 10,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    MJTouchIDStateInvalidContext = 11,
    /**
     *  系统版本不支持TouchID (必须高于iOS 8.0才能使用)
     */
    MJTouchIDStateVersionNotSupport = 12
};


@interface MJTouchID : NSObject

typedef void (^StateBlock)(MJTouchIDState state,NSError *error);


/**
 单例类

 @return touchID
 */
+ (instancetype)touchID;

/**
 启动TouchID进行验证

 @param message 自定义提示信息
 @param fallfallBackTitle 按钮标题
 @param block  回调状态的block
 */
-(void)startMJTouchIDWithMessage:(NSString*)message
                   fallBackTitle:(NSString*)fallfallBackTitle
                      BlockState:(StateBlock)block;


@end
