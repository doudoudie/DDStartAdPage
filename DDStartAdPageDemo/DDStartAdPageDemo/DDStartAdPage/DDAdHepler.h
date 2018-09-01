//
//  DCAdHepler.h
//  DCStartPageAdDemo
//
//  Created by 黄登登 on 2018/8/28.
//  Copyright © 2018年 黄登登. All rights reserved.
//

#import <Foundation/Foundation.h>

#define StatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationPushByAdPageNotifi  @"navigationPushByAdPageNotifi"

@interface DDAdHepler : NSObject

@property (nonatomic, strong) void(^downLoadFinishBlock)(BOOL cuccess,id responseObject);

+ (instancetype)sharedManager;

//是否要显示广告图
- (BOOL)showAdImage;
// 请求数据
- (void)requestAdData;
//读取设置Json
- (NSDictionary *)readAdJson;
//读取图片路径
- (NSString *)readAdImage;

@end
