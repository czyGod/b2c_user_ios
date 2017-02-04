//
//  MsgDetailViewController.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "MsgDetailViewController.h"



@interface MsgDetailViewController () <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>


@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.navigationItem.titleView = [UILabel labelWithTitle:@"消息"];

    
    //NSString *domain = @"http://b2c.beyondin.com";
    
    // NSString *domain = @"http://zrllz.cn";

    
   // _htmlStr = [_htmlStr stringByReplacingOccurrencesOfString:@"src=\"" withString:[NSString stringWithFormat:@"%@%@", @"src=\"", domain]];
    
    _htmlStr = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p {word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16,_htmlStr];

    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth-20];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.wkWebView.configuration.userContentController addUserScript:userScript];
    
    self.wkWebView.scrollView.bounces = NO;
    [self.wkWebView loadHTMLString:_htmlStr baseURL:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}



#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSString *msgName = message.name;
    
    if ([msgName isEqualToString:@"webviewEvent"]) {
        

    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    
    [self.wkWebView sizeToFit];

    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        self.navigationItem.titleView = [UILabel labelWithTitle:string];
    }];
}



@end
