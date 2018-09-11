//
//  AppDelegate+Login.m
//  DCStartPageAdDemo
//
//  Created by 黄登登 on 2018/8/28.
//  Copyright © 2018年 黄登登. All rights reserved.
//

#import "AppDelegate+Login.h"
#import "ViewController.h"
#import "GuidePageViewController.h"
#import "DDStartAdPage.h"

#define kShowGuidePage @"SHOWGUIDEPAGE"

@implementation AppDelegate (Login)

- (void)checkLogin{
    BOOL showGuidePage = [[NSUserDefaults standardUserDefaults] boolForKey:kShowGuidePage];
    ViewController *viewController = [ViewController instanceFromXib];
    if(!showGuidePage){
        GuidePageViewController *ctrl = [GuidePageViewController instanceFromXib];
        ctrl.StartAppBlock = ^(NSDictionary *dictionary) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowGuidePage];
            self.window.rootViewController = viewController;
        };
        self.window.rootViewController = ctrl;
    }else{
        
        //if(判断用户已登录){
            self.window.rootViewController = viewController;
            [self showAdvertisingPage];
        /* }else{
            //这里执行登录的操作 那么就会出现登录的回调
        }
        */
    }
}

- (void)showAdvertisingPage{
    
    if(!self.hiddleAd && DDAdHepler.sharedManager.showAdImage) {
    
        UIWindow *testWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        DDStartAdPageCtrl *VC= [[DDStartAdPageCtrl alloc] init];
        __weak typeof(VC) weakSelf = VC;
        VC.adPageSkipBlock = ^{
            [weakSelf.view removeFromSuperview];
            self.AdWindow.hidden = YES;
            self.AdWindow = nil;
        };
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.AdWindow = testWindow;
        testWindow.windowLevel = UIWindowLevelAlert;
        testWindow.rootViewController = VC;
        [testWindow makeKeyAndVisible];
        [window makeKeyWindow];
    }
}

@end
