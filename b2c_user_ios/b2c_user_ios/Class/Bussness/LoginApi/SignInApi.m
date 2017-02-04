//
//  SignInApi.m
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "SignInApi.h"
#import "UserDefaultsUtil.h"

//#import "JPushRegIdApi.h"
//#import "UnreadMessageNumApi.h"

@implementation SignInApi {
    
    NSString *_mobile;
    NSString *_password;
    NSString *_jpushRegId;
}

- (void)getArtistUserSigninMobile:(NSString*)mobile password:(NSString*)password jpushRegId:(NSString*)jpushRegId callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(mobile);
    STRING_NIL_NULL(password);
    STRING_NIL_NULL(jpushRegId);
    
    _mobile = mobile;
    _password = password;
    _jpushRegId = jpushRegId;
    
    HttpRequestTool * tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"mall.user.login" parameters:[self publicParameters] success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 0) {
            
            [self loginSuccess:PASS_NULL_TO_NIL(responseObj[@"data"])];
            //成功回调
            callback(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
        }else{
            
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];

            //失败回调
            callback(responseObj , [responseObj[@"code"] integerValue]);
        }
        
    } failure:^(NSError *error) {
        //失败回调
        callback(nil , 1);
        
    }];
}


- (void)loginSuccess:(id)resultData {
    
    // 1、存储  user_id 等用户数据
    [Singleton sharedManager].userId = PASS_NULL_TO_NIL(resultData[@"user_id"]);
    [Singleton sharedManager].userName = _mobile;
    [Singleton sharedManager].userPassward = _password;
    
    [UserDefaultsUtil setUserDefaultName:_mobile];
    [UserDefaultsUtil setUserDefaultPassword:_password];
    //去除第三方的userId，和类型
     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"threeLoginUserId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"threeLoginType"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
//    [self requestSetJPushRegId];
//    [self UnreadMessageNumApi];
    
}

- (NSDictionary *)publicParameters
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"api_name"] = @"mall.user.login";
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    
    params[@"mobile"] = _mobile;
    
    params[@"password"] = _password;
    
    params[@"jpush_reg_id"] = _jpushRegId;
    
    params[@"token"] = [self doSign:params];
    
    return params;
}

/*
- (void)requestSetJPushRegId
{
    JPushRegIdApi * jPushRegIdApi = [[JPushRegIdApi alloc]init];
    [jPushRegIdApi setJPushRegIdJpushRegId:[Singleton sharedManager].registrationID callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
        }
    }];
}

- (void)UnreadMessageNumApi{
    UnreadMessageNumApi *unReadApi = [UnreadMessageNumApi new];
    
    [unReadApi getUnreadMessageNumCallback:^(id resultData, NSInteger code) {
        
        if (code == 0) {
            
            NSString *data = resultData;
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = data.integerValue;
        }
    }];
}
*/

@end
