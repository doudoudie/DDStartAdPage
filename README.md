# DDStartAdPage
## app启动页广告思路

最近又有做了个app启动页广告功能
虽然市面上n多的demo和方案 但我还是决定把我的也拿出来分享给大家， 因为我看了几个demo都或多或少在我的项目中有些问题。

1、广告页是设置在window的rootViewController上

2、广告页加在了系统的keywindow上

3、没有考虑特殊场景打开app时不需要显示广告页的情况

基于以上问题 我先来说说我自己的实现思路：
   
  同样是通过后台接口配置来获取是否显示广告页已经具体的广告页图片Image，在app启动的时候调用接口请求
  
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //检测数据是否有更新
    [[DDAdHepler sharedManager] requestAdData];
    
    [self checkLogin];
    
    return YES;
    
    }
    

  我为什么要在注释的地方写的是 //检测数据是否有更新 因为这里确实还做了检查是否有更新的判断，因为总不能每次启动都重新下载广告图吧 具体如下：
  
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
    

仔细看，实现的逻辑就是有一个lastUpdateTime标志。在请求完以后判断本地的json跟新请求的数据里关于lastUpdateTime这个标志是否被更新。只有新数据里的lastUpdateTime标志被更新才更新本地json已经重新下载广告图。

保存json到本地沙盒的方法

    - (void)saveAdJson:(NSDictionary *)AdJson{
        //本地应用更新成功，字典转json, 将最新的字典信息写入沙盒
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:AdJson options:NSJSONWritingPrettyPrinted error:nil];
        BOOL saveOk = [jsonData writeToFile:[self AdJsonPath] atomically:YES];
        if(saveOk){
            [self saveAdImage:AdJson[@"picture"][@"url"]];
        }
    }
   
   
下载广告图并保存到本地沙盒的方法
 
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
    
这里有个小小的逻辑是做了个3此重试的机制，万一不小心没down下来呢。


以上是保存广告页的逻辑代码，接下来就看看如何读取这个图片 他有什么逻辑？

细心的同学应该发现了 在app启动哪里我写了个 [self checkLogin]的方法调用。没错 这里就是要检测显示的逻辑开始。

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
    
    
看见没？你看清楚没？ 我是写在了一个AppDelegate的分类里面 
    [self showAdvertisingPage] 这个方法调用才是真正的显示广告页。

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
    
看了的人会疑惑 self.hiddleAd？？ DDAdHepler.sharedManager.showAdImage？？什么鬼？ 不要着急，慢慢给你道来。

这两个条件是用来判断是否显示广告页的： self.hiddleAd是用于外部条件下不显示广告页的设置，比如说你是通过推送打开app的，这个时候就可以通过此参数来控制是否要显示广告页。 DDAdHepler.sharedManager.showAdImage是广告页内部本身是否显示的条件 比如说要在某个活动时间内才显示这个广告页。

看着看着 诶 self.AdWindow？又是个什么鬼。 这是我在AppDelegate设置的一个属性，为了能够全局持有自己new的testWindow。这里就说下为什么要自己新new一个window，而不是加载keywindow的原因：
在我们的项目中，打开app的时候 还有一些其他的业务需要强弹窗，这个弹窗也是加在keywindow上的。并且业务弹窗是在广告页之后，这样就会出现一个尴尬的情况，广告页之上扶着一个业务的弹窗。 所以在此自己新new一个window并且他的windowLevel设置成UIWindowLevelAlert就解决这个问题。 你试了了嘛？


还有第一个问题，为什么不直接设置window的rootViewController
你这样设置了 在切换到工程的主界面 又得重新请求主页面需要展示的所以数据，这在时间上多少有点浪费。
如果能加载window上，既展示了广告，与此同时又请求了数据，两全其美。


以上就是我的实现思路。如有不当之处，还请不吝赐教！ 拜谢！！
    


