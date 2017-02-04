//
//  ThirdPartLoginApi.m
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "ThirdPartLoginApi.h"
#import "UserDefaultsUtil.h"
#import "Singleton.h"


//#import "JPushRegIdApi.h"
//#import "UnreadMessageNumApi.h"

@implementation ThirdPartLoginApi
{
    NSInteger _loginType;
    NSString *_uId;
    NSString* _naickname;
    NSString* _headimgurl;
}

- (void)getThirdPartLoginType:(NSInteger)type uId:(NSString*)uId nickname:(NSString*)naickname headimgul:(NSString*)headimgurl callback:(ApiRequestCallBack)callback
{

    STRING_NIL_NULL(uId);
    STRING_NIL_NULL(naickname);
    STRING_NIL_NULL(headimgurl);
    _loginType = type;
    _uId = uId;
    _naickname = naickname;
    _headimgurl = headimgurl;
    
    HttpRequestTool * tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"artist.user.thirdPartLogin" parameters:[self publicParameters] success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 0) {
            [self loginSuccess:PASS_NULL_TO_NIL(responseObj[@"data"])];
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

- (void)loginSuccess:(id)resultData {
    // 存储  user_id 等用户数据
    [Singleton sharedManager].userId = PASS_NULL_TO_NIL(resultData[@"user_id"]);
    [Singleton sharedManager].userName = PASS_NULL_TO_NIL(resultData[@"bind_mobile"]);
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",_uId] forKey:@"threeLoginUserId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //设置不同登录账号密码为空
     [UserDefaultsUtil setUserDefaultPassword:@""];
    
    // [self requestSetJPushRegId];
    // [self UnreadMessageNumApi];
}

- (NSDictionary *)publicParameters
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"api_name"] = @"artist.user.thirdPartLogin";
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    
    params[@"login_type"] =@(_loginType);
    
    params[@"id"] = _uId;
    
    if (_naickname.length > 0) {
        params[@"nickname"] = _naickname;
    }
    
    if (_headimgurl.length > 0) {
        params[@"headimgurl"] = _headimgurl;
    }
    
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
