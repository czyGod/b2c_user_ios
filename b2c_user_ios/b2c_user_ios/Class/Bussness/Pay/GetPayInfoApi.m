//
//  GetPayInfoApi.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/19.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "GetPayInfoApi.h"



@interface GetPayInfoApi ()

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, strong) NSString *payTag;


@end

@implementation GetPayInfoApi


- (void)getPayInfoByOrderId:(NSInteger)orderId payTag:(NSString*)payTag callback:(ApiRequestCallBack)callback {

    _orderId = orderId;
    _payTag = payTag;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"merchant.pay.getPayInfoByOrderId"
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

- (NSDictionary *)publicParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    params[@"api_name"] = @"merchant.pay.getPayInfoByOrderId";
    
    params[@"order_id"] = @(_orderId);
    params[@"pay_tag"] = _payTag;
    
    params[@"token"] = [self doSign:params];
    return params;
}





@end
