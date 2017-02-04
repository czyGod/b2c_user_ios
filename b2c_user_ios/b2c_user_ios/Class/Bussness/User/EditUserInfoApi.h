//
//  EditUserInfoApi.h
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "BaseApi.h"

@interface EditUserInfoApi : BaseApi
/**
 *  修改用户信息(merchant.user.editUserInfo)
 */

- (void)getEditUserInfoNickName:(NSString*)nickName email:(NSString*)email sex:(NSInteger)sex wxAccount:(NSString*)wxAccount headimgurl:(NSString*)headimgurl callback:(ApiRequestCallBack)callback;

@end
