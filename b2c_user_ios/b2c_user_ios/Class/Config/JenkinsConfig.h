//
//  JenkinsConfig.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 17/1/23.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <Foundation/Foundation.h>



static NSString *JenkinsDomain = @"JenkinsDomain";    // 域名
static NSString *JenkinsBundleId = @"JenkinsBundleId";   // bundleId
static NSString *JenkinsAppName = @"JenkinsAppName";  //AppName
static NSString *JenkinsAppBuild = @"JenkinsAppBuild";  //App测试版本号


// 极光推送
static NSString *JenkinsJpushAppKey = @"JenkinsJpushAppKey";  // 极光推送Appkey


// 百度地图
static NSString *JenkinsBaiduMapAppKey = @"JenkinsBaiduMapAppKey";  // 百度地图Appkey


// 蒲公英
static NSString *JenkinsPgyAppKey = @"JenkinsPgyAppKey";  // 蒲公英Appkey


// 微信支付
static NSString *JenkinsWXAppID = @"JenkinsWXAppID";  //  WX Appid
static NSString *JenkinsWXAppSecret = @"JenkinsWXAppSecret";  //  WX AppSecret
static NSString *JenkinsWXURL = @"JenkinsWXURL";  //  WX URL

//支付宝支付
static NSString *JenkinsAlipaySchemesKey = @"JenkinsAlipaySchemesKey";  // 支付宝设置回调 scheme

//银联支付
static NSString *JenkinsUnionPayMode = @"JenkinsUnionPayMode";  // 银联开发模式 00 正式环境 01测试环境


// 第三方分享、登录
static NSString *JenkinsUMAppKey = @"JenkinsUMAppKey";  //  友盟Appkey

//QQ
static NSString *JenkinsQQAppID = @"JenkinsQQAppID";  //  腾讯QQ AppID
static NSString *JenkinsQQAppKey = @"JenkinsQQAppKey";  // 腾讯QQ Appkey
static NSString *JenkinsQQURL = @"JenkinsQQURL";  // 腾讯QQ 回调URL

//Sina
static NSString *JenkinsSinaAppKey = @"JenkinsSinaAppKey";   // 新浪微博 Appkey
static NSString *JenkinsSinaAppSecret = @"JenkinsSinaAppSecret";   // 新浪微博 APP Secret
static NSString *JenkinsSinaURL = @"JenkinsSinaURL";   // 新浪 回调URL

//DouBan
static NSString *JenkinsDoubanAppKey = @"JenkinsDoubanAppKey";   // 豆瓣 AppKey
static NSString *JenkinsDoubanAppSecret = @"JenkinsDoubanAppSecret";   // 豆瓣 AppSecret

//Twitter
static NSString *JenkinsTwitterAppID = @"JenkinsTwitterAppID";   // Twitter APP ID
static NSString *JenkinsTwitterAppKey = @"JenkinsTwitterAppKey";   // Twitter APP SECRET
static NSString *JenkinsTwitterURL = @"JenkinsTwitterURL";   // Twitter APP 回调URL

//Facebook
static NSString *JenkinsFacebookAppID = @"JenkinsFacebookAppID";   // facebook APP ID
static NSString *JenkinsFacebookAppKey = @"JenkinsFacebookAppKey";   // facebook APP SECRET
static NSString *JenkinsFacebookURL = @"JenkinsFacebookURL";   // facebook APP 回调URL


@class JenkinsConfig;

#define JenkinsConfigValue(JenkinsKey, defaultValue)  \
([JenkinsConfig getValueForKey:JenkinsKey] ?  [JenkinsConfig getValueForKey:JenkinsKey] : defaultValue)


@interface JenkinsConfig : NSObject



+ (NSString*)getValueForKey:(NSString*)key;







@end
