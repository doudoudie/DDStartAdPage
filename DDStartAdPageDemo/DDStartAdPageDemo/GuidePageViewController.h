//
//  GuidePageViewController.h
//  DCStartPageAdDemo
//
//  Created by 黄登登 on 2018/8/28.
//  Copyright © 2018年 黄登登. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageViewController : UIViewController

@property (nonatomic, copy) void(^StartAppBlock)(NSDictionary *dictionary);

+ (instancetype)instanceFromXib;

@end
