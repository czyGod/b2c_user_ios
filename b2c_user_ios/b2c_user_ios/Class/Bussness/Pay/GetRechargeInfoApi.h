//
//  GetRechargeInfoApi.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/19.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetRechargeInfoApi : BaseApi


- (void)getRechargeInfoWithAmount:(NSString*)amount paywayId:(NSInteger)paywayId callback:(ApiRequestCallBack)callback;



@end
