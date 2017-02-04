//
//  HomeViewController.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "NavigationController.h"
#import "UserDefaultsUtil.h"

#import <WebKit/WebKit.h>
#import "UIImage+Custom.h"

#import "UploadImageApi.h"
#import "EditUserInfoApi.h"
#import "LogoutApi.h"

#import <SDWebImageDownloader.h>


#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>

#import "ShareView.h"
#import "SelectPhotoUtil.h"

#import "Singleton.h"

#import "MsgDetailViewController.h"

#import "GetPayInfoApi.h"
#import "GetRechargeInfoApi.h"

#import "WXApi.h"

#import <SDWebImage/UIImage+GIF.h>

typedef NS_ENUM(NSUInteger, ShareContentType) {
    ShareContentTypePromo, // 推广码
    ShareContentTypeItem, // 商品
};


@interface HomeViewController () <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIButton *leftbutton;

// 用户头像
@property (nonatomic, strong) NSString *headImg;

// 分享商品信息
@property (nonatomic, strong) NSDictionary *itemDic;

@property (nonatomic, assign) ShareContentType shareContentType;


@property (nonatomic, strong) HttpRequestTool *httpRequestTool;



@end

@implementation HomeViewController


#pragma mark - Init
- (void)initNavigationBarView {
    

    _leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftbutton setImage:[UIImage imageNamed:@"return_ic"] forState:UIControlStateNormal];
    _leftbutton.frame = CGRectMake(0, 0, 20, 20);
    [_leftbutton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftbutton];
}

- (void)initShareView {

    ShareView *shareView = [ShareView shareView];
    [self.navigationController.view addSubview:shareView];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBarView];
    
    [self handleReturnButton];
    
    [self initShareView];
    
    [self reloadWebView];
    
    [self addNotificationObserver];
    
    // 监听网络状态变化
    [self checkNetworkStatus];
    
}

- (void)addNotificationObserver {

    // 处理推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hanleAppActiveNotification:) name:kActiveApplePushNotificaiton object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hanleAppInActiveNotification:) name:kInActiveApplePushNotificaiton object:nil];
    
    // 处理微信支付回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayOnResp:) name:kPayWxPayNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private
- (void)checkNetworkStatus {

    _httpRequestTool = [HttpRequestTool shareManage];
    [_httpRequestTool asynCheckNetworkStatus:^(MiniNetworkStatus networkStatus) {
        if (networkStatus == MiniNetworkStatusNotReachable) {
            
            [self showTextOnly:@"亲，网络似乎断开连接喽!"];
        }
        else {
            
            [self webViewLoadData];
        }
    }];
}

- (void)webViewLoadData {
    
    NSString *urlStr = self.wkWebView.URL.absoluteString;
    urlStr = PASS_NULL_TO_NIL(urlStr) ? urlStr : [Singleton sharedManager].webServiceDomain;
    
    [self wkWebViewRequestWithURL:urlStr];
}

- (void)handleReturnButton {

    _leftbutton.hidden = ![self.wkWebView canGoBack];
}

- (void)requestUpImageView:(UIImage*)image {
    
    NSData *data = UIImagePNGRepresentation(image);
    UploadImageApi *uploadImageApi = [[UploadImageApi alloc] init];
    [uploadImageApi uploadImageWithData:data callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            NSString *imgStr = PASS_NULL_TO_NIL(resultData);
            [self editUserHeadImage:imgStr];
        }
        else {
            [self showErrorMsg:resultData[@"error_msg"]];
        }
    }];
}

- (void)editUserHeadImage:(NSString*)imgStr {
    
    EditUserInfoApi *editApi = [[EditUserInfoApi alloc] init];
    [editApi getEditUserInfoNickName:nil email:nil sex:-1 wxAccount:nil headimgurl:imgStr callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            // 刷新头像
            NSString *js = [NSString stringWithFormat:@"webview_listen('img_refresh','{\"url\":\"%@\"}');", imgStr];
            [self.wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                
            }];
        }
        else {
            [self showErrorMsg:resultData[@"error_msg"]];
        }
    }];
}

- (void)logout {

    LogoutApi *logoutApi = [[LogoutApi alloc] init];
    [logoutApi getRequestLogoutCallback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            [UserDefaultsUtil setUserDefaultCookie:@""];
            
            //清空Cookie
            NSArray *cookieList = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
            for (NSHTTPCookie *cookie in cookieList) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            }
            
            [self reloadWebView];
        }
        else {
            
            [self showErrorMsg:resultData[@"error_msg"]];
        }
    }];
}

- (void)reloadWebView {

    NSString *urlStr = [Singleton sharedManager].webServiceDomain;
    [self wkWebViewRequestWithURL:urlStr];
}


- (void)wxPayWithOrderId:(NSString*)orderIdStr payTag:(NSString*)payTag {

    NSInteger orderId = [orderIdStr integerValue];
    if (orderId == 0) {
        
        [self showErrorMsg:@"订单不存在"];
        return;
    }
    
    GetPayInfoApi *getPayInfoApi = [[GetPayInfoApi alloc] init];
    [getPayInfoApi getPayInfoByOrderId:orderId payTag:payTag callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            if ([resultData isKindOfClass:[NSDictionary class]]) {
                
                [self wxpaySendPay:resultData];
            }
        }
        else {
        
            [self showTextOnly:resultData[@"error_msg"]];
        }
    }];
    
}

- (void)wxPayRecharge:(NSString*)amuontStr paywayId:(NSInteger)paywayId {

    CGFloat amount = [amuontStr floatValue];
    if (amount < 0.009) {
        [self showTextOnly:@"充值金额最低为0.01元"];
        return;
    }
    
    GetRechargeInfoApi *getRechargeInfoApi = [[GetRechargeInfoApi alloc] init];
    [getRechargeInfoApi getRechargeInfoWithAmount:amuontStr paywayId:paywayId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            if ([resultData isKindOfClass:[NSDictionary class]]) {
                
                [self wxpaySendPay:resultData];
            }
        }
        else {
            
            [self showTextOnly:resultData[@"error_msg"]];
        }
    }];
}


//微信支付
- (void)wxpaySendPay:(NSDictionary *)params {
    if (params) {
        [WXApi registerApp:[NSString convertNullOrNil:params[@"appid"]] withDescription:@"demo 2.0"];
        PayReq *payReq = [[PayReq alloc] init];
        payReq.openID = [NSString convertNullOrNil:params[@"appid"]];
        
        payReq.partnerId = [NSString convertNullOrNil:params[@"partnerid"]];
        payReq.prepayId = [NSString convertNullOrNil:params[@"prepayid"]];
        
        payReq.nonceStr = [NSString convertNullOrNil:params[@"noncestr"]];
        payReq.timeStamp = [[NSString convertNullOrNil:params[@"timestamp"]] intValue];
        payReq.package = [NSString convertNullOrNil:params[@"package"]];
        payReq.sign = [NSString convertNullOrNil:params[@"paySign"]];
        [WXApi sendReq:payReq];
        //日志输出
        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",payReq.openID,payReq.partnerId, payReq.prepayId, payReq.nonceStr, (long)payReq.timeStamp, payReq.package, payReq.sign);
    }
    
}


#pragma mark - Events
- (void)goBack {

    [self.wkWebView goBack];
}

- (void)wxPayOnResp:(NSNotification*)notification {

    NSString *strMsg = nil;
    if ([notification.object intValue] == WXSuccess) {
        
        strMsg = [NSString stringWithFormat:@"支付成功"];

        //  zrmall-api.beyondin.com  zrllz.cn
        [self wkWebViewRequestWithURL:@"http://zrmall-api.beyondin.com/FrontOrder/pre_deliver_order.html"];
    }
    else if ([notification.object intValue] == WXErrCodeUserCancel) {
        strMsg = [NSString stringWithFormat:@"%@", @"取消付款"];
    }
    else {
        strMsg = @"支付失败";
    }
    
    [self showTextOnly:strMsg];
}

- (void)hanleAppInActiveNotification:(NSNotification*)notification {

    NSDictionary *userInfo = notification.userInfo;
    
    /*
     {
     "_j_msgid" = 6326335147;
     aps =     {
     alert = "\U60a8\U7684\U8ba2\U5355\U5df2\U53d1\U8d27\Uff0c\U70b9\U51fb\U67e5\U770b";
     badge = 1;
     sound = default;
     };
     txt = "http://zrllz.cn/FrontOrder/order_detail/order_id/274";
     type = http;
     }
     
     */
    
    if ([UIApplication canOpenUrl:userInfo[@"txt"]] && [userInfo[@"type"] isEqualToString:@"order_detail"] ) {
        
        [self wkWebViewRequestWithURL:userInfo[@"txt"]];
    }
    else if ([userInfo[@"type"] isEqualToString:@"http"]) {
    
        NSString *htmlStr = userInfo[@"txt"];
        
        MsgDetailViewController *msgDetailVC = [[MsgDetailViewController alloc] init];
        msgDetailVC.htmlStr = htmlStr;
        [self.navigationController pushViewController:msgDetailVC animated:YES];
    }
    else {
    
        
    }
    

}

- (void)hanleAppActiveNotification:(NSNotification*)notification {

    // app运行在前台收到的通知
   // NSDictionary *userInfo = notification.userInfo;

    
    
}


- (void)shareAction {

    
    ShareView *shareView = [ShareView shareView];
    [shareView showWithAnimation];
    
    shareView.shareBlock = ^(ShareType shareType) {
    
        UMSocialPlatformType platType = UMSocialPlatformType_WechatSession;
        if (shareType == ShareTypeWX) {
            
            platType = UMSocialPlatformType_WechatSession;
        }
        else if (shareType == ShareTypeTimeLine) {
            
            platType = UMSocialPlatformType_WechatTimeLine;
        }
        else {
            return ;
        }
        
        if (_shareContentType == ShareContentTypeItem) {
         
            [self shareItemPlatType:platType];
        }
        else if (_shareContentType == ShareContentTypePromo) {
        
            [self sharePromoCodePlatType:platType];
        }
    
    };
}


- (void)shareItemPlatType:(UMSocialPlatformType)platType {

    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_itemDic[@"basc_pic"]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        UIImage *shareImg = image ? image : [UIImage imageNamed:@"app_icon"];
        NSString *title =_itemDic[@"item_name"];
        NSString *desc = _itemDic[@"item_desc"];
        NSString *link = _itemDic[@"share_url"];
        
        NSURL *url = [NSURL URLWithString:link];
        NSString *host = url.host;
        link = [link stringByReplacingOccurrencesOfString:host withString:@"b2c.beyondin.com"];
        
        // self.wkWebView.URL.absoluteString
        
        // http://zrllz.cn/FrontUser/my_qr_code
        
        [self shareTextToPlatformType:platType
                             shareImg:shareImg
                                title:title
                                 desc:desc
                                 link:link];
        
    }];
}


- (void)sharePromoCodePlatType:(UMSocialPlatformType)platType {


    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_headImg] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        UIImage *shareImg = image ? image : [UIImage imageNamed:@"app_icon"];
        NSString *title = @"推荐朋友注册";
        NSString *desc = @"推荐朋友注册";
        //NSString *link = @"http://b2c.beyondin.com/FrontUser/my_qr_code";
        
        
        NSString *path = self.wkWebView.URL.path;
        NSString *link= [NSString stringWithFormat:@"%@%@", @"http://b2c.beyondin.com", path];
        
        // http://zrllz.cn/FrontUser/my_qr_code
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [self shareTextToPlatformType:platType
                                 shareImg:shareImg
                                    title:title
                                     desc:desc
                                     link:link];
            
        });
       
    }];
    
}


- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType shareImg:(UIImage*)img title:(NSString*)title desc:(NSString*)desc link:(NSString *)link {
    
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:img];
    shareObject.webpageUrl = link;

    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        // UMSocialPlatformErrorType
        if (error) {
            if (error.code == 2009) {
                [self showErrorMsg:@"取消分享"];
            }
            else {
                [self showErrorMsg:@"分享失败"];
            }
        }else{

            [self showErrorMsg:@"分享成功"];
        }
    }];
}


- (void)selectImage {

    SelectPhotoUtil *photoUtil = [SelectPhotoUtil shareInstance];
    [photoUtil selectImageViewWithViewController:self success:^(UIImage *image) {
       
        [self requestUpImageView:image];
    }];
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    NSString *msgName = message.name;
    
    if ([msgName isEqualToString:@"webviewEvent"]) {
        
        [self handleWebViewEvent:message];
    }
    
}

- (void)handleWebViewEvent:(WKScriptMessage*)message {

    NSString *bodyStr = message.body;
    
    NSDictionary *messageBody = [NSString deserializeMessageJSON:bodyStr];
    
    NSString *event = messageBody[@"event"];

    if ([event isEqualToString:@"no_login"]) {
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];

        loginVC.loginSuccess = ^() {
        
            [self webViewLoadData];
        };
    }
    else if ([event isEqualToString:@"up_head"]) {
    
        [self selectImage];
    }
    else if ([event isEqualToString:@"out_login"]) {
        
        [self logout];
    }
    else if ([event isEqualToString:@"wx_pay"]) {
        
        NSDictionary *params = PASS_NULL_TO_NIL(messageBody[@"params"]);
        NSString *orderId = params[@"order_id"];
        NSString *payTag = params[@"pay_tag"];
        
        [self wxPayWithOrderId:PASS_NULL_TO_NIL(orderId) payTag:payTag];
    }
    else if ([event isEqualToString:@"wx_recharge"]) {
        
        NSDictionary *params = PASS_NULL_TO_NIL(messageBody[@"params"]);
        NSString *amount = params[@"coin_num"];
        NSInteger paywayId = [PASS_NULL_TO_NIL(params[@"payway_id"]) integerValue];
        [self wxPayRecharge:amount paywayId:paywayId];
    }
    else if ([event isEqualToString:@"head_img"]) {
        
        NSDictionary *params = PASS_NULL_TO_NIL(messageBody[@"params"]);
        _headImg = PASS_NULL_TO_NIL(params[@"img_url"]);
        
        _shareContentType = ShareContentTypePromo;
    }
    else if ([event isEqualToString:@"share_item"]) {
        
        NSDictionary *params = PASS_NULL_TO_NIL(messageBody[@"params"]);
        if ([params isKindOfClass:[NSDictionary class]]) {
            _itemDic = [NSDictionary dictionaryWithDictionary:params];
            
            _shareContentType = ShareContentTypeItem;
        }
        
    }
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {

    NSDictionary *headers = navigationAction.request.allHTTPHeaderFields;
    NSString *cookie = headers[@"Cookie"];
    NSLog(@"%@", cookie);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlPath = navigationAction.request.URL.path;
    
    if ([urlPath isEqualToString:@"/FrontUser/my_qr_code"] || [urlPath hasPrefix:@"/FrontMall/item_detail/item_id/"]) {
        
        BOOL isInstalledWX = [UIApplication canOpenUrl:@"weixin://"] || [UIApplication canOpenUrl:@"wechat://"];
        
        if (isInstalledWX) {
            [UIBarButtonItem addRightItemWithImageName:@"share_nav" frame:CGRectMake(0, 0, 16, 16) vc:self action:@selector(shareAction)];
        }
        
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    }
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

    //[self showIndicatorOnWindowWithMessage:@"加载中"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {

    //[self hideIndicatorOnWindow];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        self.navigationItem.titleView = [UILabel labelWithTitle:string];
    }];
    
    
    // 处理返回按钮
    [self handleReturnButton];
}



@end
