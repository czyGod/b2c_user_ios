//
//  AppDelegate.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/10/31.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "NavigationController.h"

#import <PgySDk/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#import <UMSocialCore/UMSocialCore.h>

#import "WXApi.h"

#import "GuideViewController.h"

#import "AppDelegate+Launch.h"

#import "HomeViewController.h"

#import "PublishViewController.h"


#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSString *channel = @"Publish channel";
static BOOL isProduction = NO;


@interface AppDelegate () <CLLocationManagerDelegate, JPUSHRegisterDelegate, WXApiDelegate>

@property (nonatomic, strong) CLLocationManager *locationManage;



@end

@implementation AppDelegate



#pragma mark - App Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    //配置服务器
    [self configServiceAddress];
    
    //配置根控制器
    [self configRootViewController];
    // 配置友盟分享
    [self configUMShare];
    
    //    NSLog(@"%@",NSHomeDirectory());
    // 配置蒲公英
    [self configPgy];
    
    
    //配置地图
    [self configMapKit];

    
    //配置极光
    [self configJPushWithOptions:launchOptions];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
 
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

// iOS9 NS_AVAILABLE_IOS
/*
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    
    return YES;
}
*/

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
        
    }
    
    
    if ([url.absoluteString hasPrefix:@"wxbc6801af1fdbe6ff://pay/"]) {
        
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return result;
}


#pragma mark 微信支付结果
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果
        NSNotification *notification = [NSNotification notificationWithName:kPayWxPayNotification object:[NSNumber numberWithInt:resp.errCode]];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}




#pragma mark DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    
}

#pragma mark - Config
- (void)configServiceAddress {

    //测试环境
    [Singleton sharedManager].httpServiceDomain = kHttpServiceDomainSandbox;
    [Singleton sharedManager].httpImageServiceDomain = kHttpImageServiceSandbox;
    [Singleton sharedManager].httpImageServiceSubmitDomain = kHttpImageServiceSubmitSandbox;
    [Singleton sharedManager].webServiceDomain = kWebServiceDomainSandbox;
}

- (void)configRootViewController {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    NavigationController *navCtrl = [[NavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = navCtrl;

    return;
    
    [self launchEventWithCompletionHandle:^(LaunchOption launchOption) {
        if (launchOption == LaunchOptionGuide) {
            
            GuideViewController *guideVC =[[GuideViewController alloc] init];
            self.window.rootViewController = guideVC;
        }
        else {
        
            HomeViewController *homeVC = [[HomeViewController alloc] init];
            NavigationController *navCtrl = [[NavigationController alloc] initWithRootViewController:homeVC];
            self.window.rootViewController = navCtrl;
            
            
//            PublishViewController *publishVC = [[PublishViewController alloc] init];
//            NavigationController *navCtrl = [[NavigationController alloc] initWithRootViewController:publishVC];
//            self.window.rootViewController = navCtrl;

        }
    }];
}


- (void)configUMShare {

    //打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57b432afe0f55a9832001a0a"];
    
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
 
    //设置微信的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXAppID appSecret:kWXAppSecret redirectURL:kWXURL];
    
}

- (void)configPgy {

    // 关闭用户反馈
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGYER_KEY_ID];
    
    NSLog(@"%@", PGYER_KEY_ID);
    // 检查更新
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGYER_KEY_ID];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}

- (void)configMapKit {
    
    _locationManage = [[CLLocationManager alloc] init];
    _locationManage.distanceFilter = 10;
    _locationManage.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManage.delegate = self;
    
    // 请求定位授权
    [_locationManage requestAlwaysAuthorization];
    
    //启动LocationService
    if (![CLLocationManager locationServicesEnabled]) {
        
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"未成功定位，请先前往“系统设置->分销商城->位置“中开启本应用的定位服务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertCtrl addAction:actionSure];
        [self.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
    }
    else {
        [_locationManage startUpdatingLocation];
    }
}

//配置极光推送
- (void)configJPushWithOptions:(NSDictionary *)launchOptions {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            
            [Singleton sharedManager].registrationID = registrationID;
            
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

#pragma mark - JPUSHRegisterDelegate
//  iOS 8 .9 后台进入前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
  
    // UIApplicationStateInactive 后台进入前台
    if (application.applicationState > 0) {
        

        [[NSNotificationCenter defaultCenter] postNotificationName:kInActiveApplePushNotificaiton object:nil userInfo:userInfo];
    }
    // UIApplicationStateActive 在前台运行
    else if (application.applicationState == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kActiveApplePushNotificaiton object:nil userInfo:userInfo];
    }
    

    completionHandler(UIBackgroundFetchResultNewData);
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
// iOS10 运行在前台接受消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        

        [[NSNotificationCenter defaultCenter] postNotificationName:kActiveApplePushNotificaiton object:nil userInfo:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10后台进入前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kInActiveApplePushNotificaiton object:nil userInfo:userInfo];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = locations.lastObject;
    _myCoordinate = currentLocation.coordinate;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationPlaceNotification object:currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"定位失败: %@", error);
}



@end
