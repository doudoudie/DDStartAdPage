//
//  DCAdPageView.h
//  DCStartPageAdDemo
//
//  Created by 黄登登 on 2018/8/28.
//  Copyright © 2018年 黄登登. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapAdPageBlock)(void);

@interface DDAdPageView : UIView

@property (nonatomic, copy) TapAdPageBlock tapAdPageBlock;
@property (nonatomic, strong) NSString *adImageFilePath;

@end
