//
//  VendorMacro.h
//  LetWeCode
//
//  Created by 崔露凯 on 15/10/28.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#ifndef VendorMacro_h
#define VendorMacro_h


// 用于上架的APPID
#define kAPPID @"387682726"

#define kDomain         @"JenkinsDomain";    // 域名
//#define kBundleId       @"JenkinsBundleId";   // bundleId
//#define kAppName        @"JenkinsAppName";  //AppName
//#define kAppBuild       @"JenkinsAppBuild";  //App测试版本号


// 极光推送
#define kJpushAppKey    JenkinsConfigValue(JenkinsJpushAppKey, @"705c801fd3ee0eee3f7cd1a8")  // 极光推送Appkey


// 百度地图(对应bundleID 为 com.beyondin.b2cUser)
#define kBaiduMapAppKey JenkinsConfigValue(JenkinsBaiduMapAppKey, @"FrsDG2395hegXUZIs40O36wRgos6fCEC")


// 蒲公英
// 对应bundleID 为 com.beyondin.b2cUser
#define PGYER_KEY_ID JenkinsConfigValue(JenkinsPgyAppKey, @"3681dd86ff701aba6f9e0ddcf2f8dbb8")

// 微信支付(艺术互动)
#define kWXAppID JenkinsConfigValue(JenkinsPgyAppKey, @"wxbc6801af1fdbe6ff")
#define kWXAppSecret JenkinsConfigValue(JenkinsPgyAppKey, @"4915a9f1cd5b00be2f350f27fea89b1e")
#define kWXURL JenkinsConfigValue(JenkinsPgyAppKey, @"http://www.beyondin.com")

//支付宝支付
#define kAlipaySchemesKey @"JenkinsAlipaySchemesKey";  // 支付宝设置回调 scheme

//银联支付
#define kUnionPayMode   @"JenkinsUnionPayMode";  // 银联开发模式 00 正式环境 01测试环境


// 第三方分享、登录
#define kUMAppKey       JenkinsConfigValue(JenkinsUMAppKey, @"57b28bbe67e58e6c18001310")  //  友盟Appkey

//QQ
#define kQQAppID        @"JenkinsQQAppID";  //  腾讯QQ AppID
#define kQQAppKey       @"JenkinsQQAppKey";  // 腾讯QQ Appkey
#define kQQURL          @"JenkinsQQURL";  // 腾讯QQ 回调URL

//Sina
#define kSinaAppKey     @"JenkinsSinaAppKey";   // 新浪微博 Appkey
#define kSinaAppSecret  @"JenkinsSinaAppSecret";   // 新浪微博 APP Secret
#define kSinaURL        @"JenkinsSinaURL";   // 新浪 回调URL

//DouBan
#define kDoubanAppKey   @"JenkinsDoubanAppKey";   // 豆瓣 AppKey
#define kDoubanAppSecret @"JenkinsDoubanAppSecret";   // 豆瓣 AppSecret

//Twitter
#define kTwitterAppID   @"JenkinsTwitterAppID";   // Twitter APP ID
#define kTwitterAppKey  @"JenkinsTwitterAppKey";   // Twitter APP SECRET
#define kTwitterURL     @"JenkinsTwitterURL";   // Twitter APP 回调URL

//Facebook
#define kFacebookAppID  @"JenkinsFacebookAppID";   // facebook APP ID
#define kFacebookAppKey @"JenkinsFacebookAppKey";   // facebook APP SECRET
#define kFacebookURL    @"JenkinsFacebookURL";   // facebook APP 回调URL

#endif /* VendorMacro_h */
