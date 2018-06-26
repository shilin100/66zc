//
//  AppDelegate.m
//  666
//
//  Created by xiaofan on 2017/9/28.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "AppDelegate.h"

#import <UMSocialCore/UMSocialCore.h>

#import "XFLoginNaviController.h"
#import "XFHomeNavController.h"
#import "XFHomeController.h"
#import "XFDoLoginController.h"
#import <Bugly/Bugly.h>
#import "Reachability.h"

#define UMeng_APPKEY @"57f710b567e58edee7004937"//UMeng appkey

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>
@property (nonatomic, strong) Reachability *reach;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [Bugly startWithAppId:@"70a1c24235"];

    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    
    [JPUSHService setupWithOption:launchOptions appKey:@"28e3b952cdc37e0e5ade677d"
                          channel:@"0"
                 apsForProduction:NO
            advertisingIdentifier:nil];

    
    // 百度地图
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"CHabmpfzjWzUGSagD1GhluhgGTVqRMxx" generalDelegate:nil];
    if (!ret) {
        NSLog(@"启动百度地图失败");
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMeng_APPKEY];
    // 配置分享平台
    [self configUSharePlatforms];
    // 注册微信支付
    [WXApi registerApp:@"wxddaeecd00afe4e53"];
    
    // 设置根控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
     BOOL flag =[USERDEFAULT boolForKey:@"isLogin"];
    if (flag) {
        XFHomeController *homeVC = [[XFHomeController alloc] init];
        XFHomeNavController *homeNav = [[XFHomeNavController alloc] initWithRootViewController:homeVC];
        self.window.rootViewController = homeNav;
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginSB" bundle:[NSBundle mainBundle]];
        
        if ([USERDEFAULT objectForKey:@"isFirstOpenApp"]) {
            UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"LoginSB" bundle:nil];
            XFDoLoginController *vc = [mainStory instantiateViewControllerWithIdentifier:@"DoLoginIdentity"];
            self.window.rootViewController = [[XFLoginNaviController alloc]initWithRootViewController:vc];
            
        }else{
            [USERDEFAULT setObject:@"1" forKey:@"isFirstOpenApp"];
            XFLoginNaviController *loginNav = sb.instantiateInitialViewController;
            self.window.rootViewController = loginNav;

        }

    }

    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reach startNotifier];
    self.reach = reach;

    
    return YES;
}

- (void)reachabilityChanged:(NSNotification*)note {
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    /*
     9      NotReachable = 0, 无网络连接
     10      ReachableViaWiFi, Wifi
     11      ReachableViaWWAN 2G/3G/4G/5G
     12      */
    if (status == NotReachable) {
        
        // 没有网络的更多操作
        // 实现类似接到电话效果   self.window.frame = CGRectMake(0, 40, __width, __height-40);
        static XFAlertView *alertReachabilityView;
        if (alertReachabilityView == nil) {
            alertReachabilityView = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您的网络连接中断或未打开网络使用权限" sureBtn:@"确定" cancleBtn:nil];
        }
        [alertReachabilityView showAlertView];

    } else if (status == ReachableViaWiFi) {
        NSLog(@"Wifi");
    } else {
        NSLog(@"3G/4G/5G");
    }
}

#pragma mark - JPush

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


#pragma mark - UMeng
/**配置分享平台*/
- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxddaeecd00afe4e53" appSecret:@"91918b96d413290a7add8bc28ae5576d" redirectURL:nil];
    /*
     
     设置分享到QQ互联的appID
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106495605"  appSecret:@"rhlOdLqU2q93TUvt" redirectURL:nil];
    
    /*
     设置新浪的appKey和appSecret
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@""  appSecret:@"" redirectURL:nil];

}

//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [WXApi handleOpenURL:url delegate:self];
//}
/**iOS 9.0*/
//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
//
//    if ([url.host isEqualToString:@"safepay"]) {
//
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:AliPayResultNotification object:resultDic];
//        }];
//
//    }
//    return [WXApi handleOpenURL:url delegate:self];
//}


/**iOS 8.0*/
/*
 {
 result = ,
 resultStatus = 6001,
 memo = 用户中途取消
 }
 */
/*
 9000 订单支付成功
 8000 正在处理中
 4000 订单支付失败
 6001 用户中途取消
 6002 网络连接出错
 */
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"])
        {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                            NSLog(@"result111 == %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:AliPayResultNotification object:resultDic];
            }];
        }
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    return result;
    
}
#pragma mark - WXApiDelegate
/**微信支付结果处理*/
-(void)onResp:(BaseResp *)resp{
    [[NSNotificationCenter defaultCenter] postNotificationName:WXPayResultNotification object:resp];
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
