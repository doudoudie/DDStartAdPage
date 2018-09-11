//
//  DCAdHepler.m
//  DCStartPageAdDemo
//
//  Created by 黄登登 on 2018/8/28.
//  Copyright © 2018年 黄登登. All rights reserved.
//

#import "DDAdHepler.h"

@implementation DDAdHepler

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self initAdPath]; //初始化数据存储路径
    return self;
}

#pragma mark - 显示和数据请求
//是否要显示广告图
- (BOOL)showAdImage{
    
    NSDictionary *jsonDictionary = [self readAdJson];
    long long startTime = [jsonDictionary[@"startTime"] longLongValue] / 1000;
    long long endTime = [jsonDictionary[@"endTime"] longLongValue] / 1000;
    
    long long ts = [[NSDate date] timeIntervalSince1970];//获取当前13位时间戳
    
    //在当前活动有效时间内
    if(ts >= startTime && ts <= endTime)
        return YES;
    return NO;
}

// 请求数据
- (void)requestAdData{
    //[xxx requestAdData:[self phoneModel] callBack:^(BOOL success, id responseObject, NSError *error) {
            //读取服务器返回的JSON数据
            NSDictionary *new_json = nil;//responseObject[@"data"][@"loadPage"];
            NSString *ts = new_json[@"lastUpdateTime"];
            //读取之前保存过的JSON数据
            NSDictionary *dictionary = [self readAdJson];
            NSString *last_ts = dictionary[@"lastUpdateTime"];
    
            //如果最后的更新时间不同 就以服务端新返回的为准 覆盖本地的
            if(![last_ts isEqualToString:ts]){
                [self saveAdJson:new_json];
            }
   // }];
}

#pragma mark - 本地缓存数据的存取
//读取设置Json
- (NSDictionary *)readAdJson{
    NSData *data = [NSData dataWithContentsOfFile:[self AdJsonPath]];
    if(!data) return nil;
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        NSLog(@"%@", error);
    }
    return dictionary;
}

//保存设置Json
- (void)saveAdJson:(NSDictionary *)AdJson{
    //本地应用更新成功，字典转json, 将最新的字典信息写入沙盒
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:AdJson options:NSJSONWritingPrettyPrinted error:nil];
    BOOL saveOk = [jsonData writeToFile:[self AdJsonPath] atomically:YES];
    if(saveOk){
        [self saveAdImage:AdJson[@"picture"][@"url"]];
    }
}

//读取图片路径
- (NSString *)readAdImage{
    NSDictionary *AdJson = [self readAdJson];
    NSURL *url = [NSURL URLWithString:AdJson[@"picture"][@"url"]];
    NSString *fileName = [url lastPathComponent];
    NSString *pictureName = fileName;
    return [NSString stringWithFormat:@"%@/%@",[self AdImageDirPath],pictureName];
}

// 保存图片
- (void)saveAdImage:(NSString *)image_url{
    __block NSInteger retryCount = 0;
    __weak typeof(self) weak_self = self;
    self.downLoadFinishBlock = ^(BOOL success) {
        if(!success){
            retryCount ++;
            if(retryCount <= 3){
                [weak_self downLoadAdImage:image_url finishHandler:weak_self.downLoadFinishBlock];
            }
        }
    };
    
    [self downLoadAdImage:image_url finishHandler:self.downLoadFinishBlock];
}

#pragma mark - 下载图片
// 下载图片
- (void)downLoadAdImage:(NSString *)url finishHandler:(void(^)(BOOL success))finish{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *AdImageDirPath = [self AdImageDirPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath:AdImageDirPath]){
            [fileManager createDirectoryAtPath:AdImageDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if(data){
            [data writeToFile:AdImageDirPath atomically:YES];
        }else{
            if(finish) finish(NO);
        }
   });
}


#pragma mark - 缓存数据路径
// 初始化数据缓存路径
- (void)initAdPath
{
    NSString *AdDirPath = [self AdDirPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:AdDirPath]){
        [fileManager createDirectoryAtPath:AdDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//数据缓存文件夹路径
- (NSString *)AdDirPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *AdDirPath = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/DDAd",AdDirPath];
}

//数据Json路径
- (NSString *)AdJsonPath{
    return [NSString stringWithFormat:@"%@/Ad.json",[self AdDirPath]];
}

//广告image文件夹路径
- (NSString *)AdImageDirPath{
    return [NSString stringWithFormat:@"%@/image",[self AdDirPath]];
}

@end
