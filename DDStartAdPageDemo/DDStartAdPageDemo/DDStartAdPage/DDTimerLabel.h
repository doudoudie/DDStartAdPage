//
//  DCTimerLabel.h
//  DCStartPageAdDemo
//
//  Created by 黄登登 on 2018/8/28.
//  Copyright © 2018年 黄登登. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CountDownFinishBlock)(void);

@interface DDTimerLabel : UILabel

// 倒计时结束的回调
@property (nonatomic, copy) CountDownFinishBlock countDownFinishBlock;

- (void)stopTimer;

@end
