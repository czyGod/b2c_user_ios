//
//  SetLoginPasswordApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface SetLoginPasswordApi : BaseApi
/**
 * 修改登录密码 findPasswordBySms
 */

- (void)setLoginPasswordVerifyCode:(NSString*)verifyCode mobile:(NSString*)mobile newPassword:(NSString*)newPassword callback:(ApiRequestCallBack)callback;
@end
