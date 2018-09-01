//
//  DCAdPageView.m
//  DCStartPageAdDemo
//
//  Created by 黄登登 on 2018/8/28.
//  Copyright © 2018年 黄登登. All rights reserved.
//

#import "DDAdPageView.h"

@interface DDAdPageView ()

@property (nonatomic ,strong) UIImageView *adPageImgView;

@end

@implementation DDAdPageView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.adPageImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.adPageImgView.userInteractionEnabled = YES;
        [self addSubview:_adPageImgView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.adPageImgView addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //读取数据显示的方式
    /*NSData *data = [NSData dataWithContentsOfFile:self.adImageFilePath];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];*/
    
    UIImage *image = [UIImage imageNamed:@"AdvertisingPage"];
    self.adPageImgView.image = image;
}

#pragma mark --- 响应点击广告页的方法
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (self.tapAdPageBlock) {
        self.tapAdPageBlock();
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
