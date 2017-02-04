//
//  SignUpApi.m
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "SignUpApi.h"

@implementation SignUpApi {
    
    NSString *_mobile;
    NSString *_password;
    NSString *_verifyCode;
}

- (void)userSignupMobile:(NSString*)mobile password:(NSString*)password verifyCode:(NSString*)verifyCode Callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(mobile);
    STRING_NIL_NULL(password);
    STRING_NIL_NULL(verifyCode);
    _mobile = mobile;
    _password = password;
    _verifyCode = verifyCode;
    
    HttpRequestTool * tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"merchant.user.register" parameters:[self publicParameters] success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 0) {
            //成功回调
            callback(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
        }else{
            //失败回调
            callback(responseObj , 1);
        }
        
    } failure:^(NSError *error) {
        //失败回调
        callback(nil , 1);
        
    }];
}

- (NSDictionary *)publicParameters {
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"api_name"] = @"merchant.user.register";
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    
    params[@"mobile"] = _mobile;
    
    params[@"password"] = _password;
    
    params[@"verify_code"] = _verifyCode;
    
    params[@"token"] = [self doSign:params];
    
    return params;
}

@end
