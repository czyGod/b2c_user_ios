//
//  HttpRequestTool.m
//  AFNetworkingTool
//
//  Created by 崔露凯 on 15/9/25.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "HttpRequestTool.h"
#import "HttpRequestService.h"
#import "AFNetworking.h"

#import "SigninApi.h"
#import "UserDefaultsUtil.h"



@interface HttpRequestTool ()



@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManage;




@end


@implementation HttpRequestTool {
    
    NSMutableDictionary *_requestList;
    
}

+ (HttpRequestTool *)shareManage {
    
    static HttpRequestTool *httpRequestTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        httpRequestTool = [[super alloc] init];
        
    });
    return httpRequestTool;
}

- (instancetype)init {
    if (self = [super init]) {
        _requestList = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSTimeInterval)timeOut {
    if (_timeOut == 0) {
        _timeOut = 15;
    }
    return _timeOut;
}

- (void)asynCheckNetworkStatus:(MiniNetworkStatusCallback)networkBlock {
    
    AFNetworkReachabilityManager *reachabilityManage = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManage startMonitoring];
    [reachabilityManage setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            networkBlock(MiniNetworkStatusUnknown);
        }
        else if (status == AFNetworkReachabilityStatusNotReachable) {
            networkBlock(MiniNetworkStatusNotReachable);
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            networkBlock(MiniNetworkStatusReachableViaWWAN);
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            networkBlock(MiniNetworkStatusReachableViaWifi);
        }
    }];
    
    _reachabilityManage = reachabilityManage;
}

- (void)asynGetWithBaseUrl:(NSString *)baseUrl apiMethod:(NSString *)apiMethod parameters:(NSDictionary *)params success:(MiniHttpRequestServiceSuccess)successBlock failure:(MiniHttpRequestServiceFailure)failure {
    
    HttpRequestObject *requestObj = [[HttpRequestObject alloc] init];
    if (baseUrl) {
        requestObj.requestUrl = baseUrl;
    }
    else {
        requestObj.requestUrl = self.baseUrl;
    }
    requestObj.requestTimeout = self.timeOut;
    requestObj.requestParams = params;
    requestObj.apiMethod = apiMethod;
    requestObj.requestMethod = MiniRequestMethodGet;
    requestObj.responseType = MiniRequestResponseTypeJSON;
    requestObj.successBlock = successBlock;
    requestObj.failureBlock = failure;
    _requestList[apiMethod] = requestObj;
    
    [HttpRequestService asynRequest:requestObj success:^(id responseObj) {
        [_requestList removeObjectForKey:apiMethod];
        successBlock(responseObj);
        
    } failure:^(NSError *error) {
        [_requestList removeObjectForKey:apiMethod];
        failure(error);
    }];
}

- (void)asynPostWithBaseUrl:(NSString *)baseUrl apiMethod:(NSString *)apiMethod parameters:(NSDictionary *)params success:(MiniHttpRequestServiceSuccess)successBlock failure:(MiniHttpRequestServiceFailure)failure {
    
    HttpRequestObject *requestObj = [[HttpRequestObject alloc] init];
    if (baseUrl) {
        requestObj.requestUrl = baseUrl;
    }
    else {
        requestObj.requestUrl = self.baseUrl;
    }
    requestObj.requestTimeout = self.timeOut;
    requestObj.requestParams = params;
    requestObj.apiMethod = apiMethod;
    requestObj.requestMethod = MiniRequestMethodPost;
    requestObj.responseType = MiniRequestResponseTypeJSON;
    requestObj.successBlock = successBlock;
    requestObj.failureBlock = failure;
    _requestList[apiMethod] = requestObj;
    
    [HttpRequestService asynRequest:requestObj success:^(id responseObj) {
        
        // 判断是否为Session失效
        if ([PASS_NULL_TO_NIL(responseObj[@"code"]) integerValue] == 40011) {
            
            NSString *mobile = [UserDefaultsUtil getUserDefaultName];
            NSString *password = [UserDefaultsUtil getUserDefaultPassword];
            
            // 用户登录
            SignInApi *signInApi = [[SignInApi alloc] init];
            [signInApi getArtistUserSigninMobile:mobile password:password jpushRegId:[Singleton sharedManager].registrationID  callback:^(id resultData, NSInteger code) {
                
                // 登录成功后，继续请求上一条失败的请求
                if (code == 0) {
                    [self asynPostWithBaseUrl:baseUrl apiMethod:apiMethod parameters:params success:successBlock failure:failure];
                }
                else {
                    
                    //failure(nil);
                    successBlock(@{@"code": @"47006", @"error_msg": @"用户未登录"});
                }
                
            }];
            
        }
        else {
            
            // 若Session过期,  则不回调block
            successBlock(responseObj);
        }
        
        [_requestList removeObjectForKey:apiMethod];
    } failure:^(NSError *error) {
        
        [_requestList removeObjectForKey:apiMethod];
        failure(error);
    }];
}

- (void)asynPostUploadWithUrl:(NSString *)baseurl apiMethod:(NSString *)apiMethod parameters:(NSDictionary *)parameters fileData:(NSData *)data success:(MiniHttpRequestServiceSuccess)success failure:(MiniHttpRequestServiceFailure)failure {
    
    HttpRequestObject *requestObj = [[HttpRequestObject alloc] init];
    if (baseurl)
    {
        requestObj.requestUrl = baseurl;
    }
    else
    {
        requestObj.requestUrl = self.baseUrl;
    }
    requestObj.requestTimeout = self.timeOut;
    requestObj.requestParams = parameters;
    requestObj.apiMethod = apiMethod;
    requestObj.requestMethod = MiniRequestMethodPost;
    requestObj.responseType = MiniRequestResponseTypeJSON;
    requestObj.successBlock = success;
    requestObj.failureBlock = failure;
    _requestList[apiMethod] = requestObj;
    
    [HttpRequestService uploadRequest:requestObj
                             fileData:data
                              success:^(id responseObj){
                                  [_requestList removeObjectForKey:apiMethod];
                                  success(responseObj);
                              }
                              failure:^(NSError *error){
                                  [_requestList removeObjectForKey:apiMethod];
                                  failure(error);
                              }];
    
}

- (void)resumeRequestWithApiMethid:(NSString*)apiMethod {
    
    HttpRequestObject *requestObj = _requestList[apiMethod];
    [requestObj.requestOperation resume];
}

- (void)suspendRequestWithApiMethid:(NSString*)apiMethod {
    
    HttpRequestObject *requestObj = _requestList[apiMethod];
    [requestObj.requestOperation suspend];
}

- (void)cancleRequestWithApiMethod:(NSString *)apiMethod {
    
    HttpRequestObject *requestObj = _requestList[apiMethod];
    [HttpRequestService cancleRequest:requestObj];
    [_requestList removeObjectForKey:apiMethod];
}

- (void)cancleAllRequest {
    
    for (NSString *apiMethod in [_requestList allKeys]) {
        HttpRequestObject *requestObj = _requestList[apiMethod];
        [HttpRequestService cancleRequest:requestObj];
        [_requestList removeObjectForKey:apiMethod];
    }
}

@end
