//
//  DCTimerLabel.m
//  DCStartPageAdDemo
//
//  Created by 黄登登 on 2018/8/28.
//  Copyright © 2018年 黄登登. All rights reserved.
//

#import "DDTimerLabel.h"

@interface DDTimerLabel ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isStop; //是否停止计时器

@end

@implementation DDTimerLabel

- (void)dealloc {
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isStop = NO;
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 12.5;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        self.textAlignment = NSTextAlignmentCenter;
        self.text = @"3 跳过";
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:12];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        
        
        _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)stopTimer{
    _isStop = YES;
    [_timer invalidate];
    _timer = nil;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (self.isStop == NO) {
        [_timer invalidate];
        _timer = nil;
        if (self.countDownFinishBlock) {
            self.countDownFinishBlock();
        }
    }
}

- (void)handleTimer:(NSTimer *)timer {
    static int s = 0;
    s ++;
    self.text = [NSString stringWithFormat:@"%d 跳过",3 - s];
    if (self.isStop == NO) {
        if (s == 3) {
            [_timer invalidate];
            _timer = nil;
            if (self.countDownFinishBlock) {
                self.countDownFinishBlock();
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
