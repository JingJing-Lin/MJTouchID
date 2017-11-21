//
//  ViewController.m
//  MJTouchID
//
//  Created by YXCZ on 17/4/25.
//  Copyright © 2017年 林民敬. All rights reserved.
//  http://www.jianshu.com/u/2a2051ad6a5d

#import "ViewController.h"
#import "MJTouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *touchIDButton = [[UIButton alloc] init];
    [touchIDButton setBackgroundImage:[UIImage imageNamed:@"touchID"] forState:UIControlStateNormal];
    [touchIDButton addTarget:self action:@selector(touchVerification) forControlEvents:UIControlEventTouchDown];
    touchIDButton.frame = CGRectMake((self.view.frame.size.width / 2) - 40, (self.view.frame.size.height / 2) - 40, 80, 80);
    [self.view addSubview:touchIDButton];

    [self touchVerification];
}

-(void)touchVerification
{
    [[MJTouchID touchID]startMJTouchIDWithMessage:nil fallBackTitle:nil BlockState:^(MJTouchIDState state, NSError *error) {
        
        if (state == MJTouchIDStateNotSupport) {
            NSLog(@"--当前设备不支持TouchID");
        }else if (state == MJTouchIDStateUserCancel){
            NSLog(@"--TouchID 被用户手动取消");
        }else if (state == MJTouchIDStateSuccess){
            NSLog(@"--TouchID验证成功");
        }else if (state == MJTouchIDStateFail){
            NSLog(@"--验证失败");
        }else if (state == MJTouchIDStateInputPassword){
            NSLog(@"--用户选择手动输入密码");
        }
        
        // 在使用中你需要根据回调的状态进行处理,需要处理什么就处理什么
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
