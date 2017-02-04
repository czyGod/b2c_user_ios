//
//  EditUserInfoApi.m
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "EditUserInfoApi.h"
@interface EditUserInfoApi ()
{
    NSString *_nickname;
    NSString *_email;
    NSInteger _sex;
    NSString *_wxAccount;
    NSString *_headimgurl;
}
@end
@implementation EditUserInfoApi

- (void)getEditUserInfoNickName:(NSString *)nickName email:(NSString *)email sex:(NSInteger)sex wxAccount:(NSString *)wxAccount headimgurl:(NSString *)headimgurl callback:(ApiRequestCallBack)callback
{
    STRING_NIL_NULL(nickName);
    STRING_NIL_NULL(email);
    STRING_NIL_NULL(wxAccount);
    STRING_NIL_NULL(headimgurl);
    
    _nickname  = nickName;
    _email = email;
    _sex = sex;
    _wxAccount = wxAccount;
    _headimgurl = headimgurl;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"merchant.user.editUserInfo"
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
    params[@"api_name"] = @"merchant.user.editUserInfo";
    
    if (_nickname.length > 0) {
        params[@"nickname"] = _nickname;
    }
    if (_email.length > 0) {
        params[@"email"] = _email;
    }
    if (_sex >= 0) {
        params[@"sex"] = @(_sex);
    }
    if (_wxAccount.length > 0) {
        params[@"wx_account"] = _wxAccount;
    }
    if (_headimgurl.length >0) {
        params[@"headimgurl"] = _headimgurl;
    }
    params[@"token"] = [self doSign:params];
    return params;
}

@end
