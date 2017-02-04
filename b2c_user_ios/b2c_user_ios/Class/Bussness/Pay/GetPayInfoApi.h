//
//  GetPayInfoApi.h
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/19.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetPayInfoApi : BaseApi


- (void)getPayInfoByOrderId:(NSInteger)orderId payTag:(NSString*)payTag callback:(ApiRequestCallBack)callback;



@end
