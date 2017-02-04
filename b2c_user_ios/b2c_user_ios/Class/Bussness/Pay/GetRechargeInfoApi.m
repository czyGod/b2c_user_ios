//
//  GetRechargeInfoApi.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/19.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "GetRechargeInfoApi.h"



@interface GetRechargeInfoApi ()

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, assign) NSInteger paywayId;


@end

@implementation GetRechargeInfoApi

- (void)getRechargeInfoWithAmount:(NSString*)amount paywayId:(NSInteger)paywayId callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(amount);
    _amount = amount.copy;
    _paywayId = paywayId;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"merchant.pay.getRechargeInfo"
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
    params[@"api_name"] = @"merchant.pay.getRechargeInfo";
    
    params[@"amount"] = _amount;
    params[@"payway_id"] = @(_paywayId);
    
    params[@"token"] = [self doSign:params];
    return params;
}



@end
