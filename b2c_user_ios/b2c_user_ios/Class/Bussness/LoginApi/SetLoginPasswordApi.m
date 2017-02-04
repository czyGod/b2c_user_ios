//
//  SetLoginPasswordApi.m
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "SetLoginPasswordApi.h"

@implementation SetLoginPasswordApi{
    NSString* _mobile;
    NSString* _newPassword;
    NSString* _verifyCode;
}

- (void)setLoginPasswordVerifyCode:(NSString *)verifyCode mobile:(NSString *)mobile newPassword:(NSString *)newPassword callback:(ApiRequestCallBack)callback
{
    STRING_NIL_NULL(mobile);
    STRING_NIL_NULL(newPassword);
    STRING_NIL_NULL(verifyCode);
    _mobile = mobile;
    _newPassword = newPassword;
    _verifyCode = verifyCode;
    
    HttpRequestTool * tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"merchant.user.findPasswordBySms" parameters:[self publicParameters] success:^(id responseObj) {
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

- (NSDictionary *)publicParameters
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"api_name"] = @"merchant.user.findPasswordBySms";
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    
    params[@"mobile"] = _mobile;
    
    params[@"new_password"] = _newPassword;
    
    params[@"verify_code"] = _verifyCode;
    
    params[@"token"] = [self doSign:params];
    
    return params;
}

@end
