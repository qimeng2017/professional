//
//  AppDelegate.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LNTabBarVC.h"
#import "WXApiManager.h"
#import "LNLottoryConfig.h"
#import "UserStore.h"
#import "LNUserInfoModel.h"
#import "StoreManager.h"
#import <Bugly/Bugly.h>
#import "HRSystem.h"
#import <UMMobClick/MobClick.h>
#import "HRNetworkTools.h"
#import "XHLaunchAd.h"
#import "CoverViewController.h"
@interface AppDelegate ()<LoginViewControllerDelegate>
@property (nonatomic, strong) LNTabBarVC *LNTabBarViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"ok");
    if (!UserDefaultObjectForKey(LOTTERY_HOST_NAME_SEVER)) {
        UserDefaultSetObjectForKey(@"https://caipiao.asopeixun.com:6688", LOTTERY_HOST_NAME_SEVER);
    }
    [WXApi registerApp:kAuthOpenID withDescription:@"demo 2.0"];
    BuglyConfig *bugConfig = [[BuglyConfig alloc]init];
    bugConfig.blockMonitorEnable = YES;
    bugConfig.unexpectedTerminatingDetectionEnable = YES;
    bugConfig.debugMode = YES;
    bugConfig.channel = [HRSystem appName];
    bugConfig.version = [HRSystem bundleVersion];
    [Bugly startWithAppId:kBuglyAppid config:bugConfig];
    
    UMConfigInstance.appKey = UM_appkey;
    [MobClick startWithConfigure:UMConfigInstance];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self adViewController];
   
    [self.window makeKeyAndVisible];
    [[StoreManager sharedInstance]startManager];
    return YES;
}
- (void)adViewController{
    CoverViewController *coverVC = [[CoverViewController alloc]initWithFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height) showFinish:^{
        NSString *userID = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
        NSString *buildVersion = [HRSystem bundleVersion];
        if (userID&&UserDefaultObjectForKey(buildVersion)) {
            self.LNTabBarViewController = [[LNTabBarVC alloc] init];
            self.window.rootViewController = self.LNTabBarViewController;
            
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.delegate = self;
            self.window.rootViewController = loginVC;
        }
    }];
    self.window.rootViewController = coverVC;
//    [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height) setAdImage:^(XHLaunchAd *launchAd) {
//        
//        //未检测到广告数据,启动页停留时间,不设置默认为3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
//        //launchAd.noDataDuration = 4;
//        
//        //获取广告数据
//        
//        [self requestImageData:^(NSString *imgUrl, NSInteger duration, NSString *openUrl) {
//            
//            /**
//             *  2.设置广告数据
//             */
//            
//            //定义一个weakLaunchAd
//            
//            __weak __typeof(launchAd) weakLaunchAd = launchAd;
//            [launchAd setImageUrl:imgUrl duration:duration skipType:SkipTypeNone options:XHWebImageDefault completed:^(UIImage *image, NSURL *url) {
//                
//            } click:^{
//                
//   
//            }];
//            
//        }];
//        
//    } showFinish:^{
//        
//        //广告展示完成回调,设置window根控制器
//       
//            NSString *userID = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
//            NSString *buildVersion = [HRSystem bundleVersion];
//            if (userID&&UserDefaultObjectForKey(buildVersion)) {
//                self.LNTabBarViewController = [[LNTabBarVC alloc] init];
//                self.window.rootViewController = self.LNTabBarViewController;
//            }else{
//                LoginViewController *loginVC = [[LoginViewController alloc]init];
//                loginVC.delegate = self;
//                self.window.rootViewController = loginVC;
//            }
//       
//        
//        
//    }];

}
/**
 *  模拟:向服务器请求广告数据
 *
 *  @param imageData 回调imageUrl,及停留时间,跳转链接
 */
-(void)requestImageData:(void(^)(NSString *imgUrl,NSInteger duration,NSString *openUrl))imageData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(imageData)
        {
            imageData(nil,3,@"http://www.returnoc.com");
        }
    });
}


- (void)userLoginSucess{
    self.LNTabBarViewController = [[LNTabBarVC alloc] init];
    self.window.rootViewController = self.LNTabBarViewController;
    [self.window makeKeyAndVisible];
    NSString *buildVersion = [HRSystem bundleVersion];
    UserDefaultSetObjectForKey(@"sucess", buildVersion);
    NSString *userId = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    if (userId) {
        [[UserStore sharedInstance]requestGetUserInfoWithUserId:userId sucess:^(NSURLSessionDataTask *task, id responseObject) {
            LNUserInfoModel *model = [[LNUserInfoModel alloc]initWithDictionary:responseObject error:nil];
            UserDefaultSetObjectForKey(model.login_type, @"login_type");
           // NSLog(@"%@",responseObject);
            [LNUserInfoModel saveUserInfo:userId userInfo:model];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"%@",error);
        }];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

   
    [[StoreManager sharedInstance]startManager];
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.absoluteString hasPrefix:@"wx"]) {
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
        return YES;
    
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.absoluteString hasPrefix:@"wx"]) {
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
        return YES;
}
//竖屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
