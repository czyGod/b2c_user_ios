//
//  UserInfoApi.h
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "BaseApi.h"

@interface UserInfoApi : BaseApi
/**
 *   获取用户信息(merchant.user.getUserInfo)
 */

- (void)getUserInfoCallback:(ApiRequestCallBack)callback;

@end
