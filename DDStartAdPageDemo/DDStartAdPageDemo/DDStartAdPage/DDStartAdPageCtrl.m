//
//  DCStartPageAdViewController.m
//  DCStartPageAdDemo
//
//  Created by 黄登登 on 2018/8/28.
//  Copyright © 2018年 黄登登. All rights reserved.
//

#import "DDStartAdPageCtrl.h"
#import "DDAdPageView.h"
#import "DDTimerLabel.h"
#import "DDAdHepler.h"

@interface DDStartAdPageCtrl ()
@property (nonatomic, strong) DDAdPageView *adPageView;
@property (nonatomic, strong) DDTimerLabel *timerLabel;
@end

@implementation DDStartAdPageCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showAdPageView];
}

- (void)showAdPageView{
    __weak __typeof(self)weakSelf = self;
    self.adPageView = [[DDAdPageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.adPageView.tapAdPageBlock = ^{
        [weakSelf.timerLabel stopTimer];
        [weakSelf removeAdPageView];
        //读取保存的广告JSON数据
        NSDictionary *dictionary = [[DDAdHepler sharedManager] readAdJson];
        //发通知做业务跳转
        [[NSNotificationCenter defaultCenter] postNotificationName:kNavigationPushByAdPageNotifi object:nil userInfo:dictionary];
    };
    [self.view addSubview:self.adPageView];
    
    self.timerLabel = [[DDTimerLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80,StatusBarHeight, 60, 25)];
    self.timerLabel.countDownFinishBlock = ^{
        [weakSelf removeAdPageView];
    };
    [self.adPageView addSubview:self.timerLabel];
}

//从自定义的Window上移除广告页
- (void)removeAdPageView {
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.8 animations:^{
        weakSelf.adPageView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1);
        weakSelf.adPageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (weakSelf.adPageSkipBlock) {
            weakSelf.adPageSkipBlock();
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
