//
//  SetPasswordApi.m
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "SetPasswordApi.h"
@interface SetPasswordApi ()
{
    NSString * _oldPassword;
    NSString * _password;
}
@end
@implementation SetPasswordApi

- (void)getSetPasswordOldPassword:(NSString *)oldPassword password:(NSString *)password callback:(ApiRequestCallBack)callback
{
    STRING_NIL_NULL(oldPassword);
    STRING_NIL_NULL(password);
    _oldPassword = oldPassword;
    _password = password;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"merchant.user.setPassword"
                   parameters:[self publicParameters]
                      success:^(id responseObj) {
                          
                          if ([responseObj[@"code"] integerValue] == 0) {
                              // 成功回调
                              callback(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
                          }
                          else {
                              // 失败回调
                              callback(responseObj, 1);
                          }
                      }
                      failure:^(NSError *error) {
                          // 失败回调
                          callback(nil, 1);
                      }];
}

- (NSDictionary *)publicParameters
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    params[@"api_name"] = @"merchant.user.setPassword";
    params[@"old_password"] = _oldPassword;
    params[@"new_password"] = _password;
 
    params[@"token"] = [self doSign:params];
    return params;
}
@end
