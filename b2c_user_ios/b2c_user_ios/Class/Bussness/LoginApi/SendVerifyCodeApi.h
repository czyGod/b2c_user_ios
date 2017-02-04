//
//  SendVerifyCodeApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface SendVerifyCodeApi : BaseApi

/**
 *  2.1.7 发送验证码(artist.user.sendVerifyCode)
 */

- (void)userSendVerifyCodeWithMobile:(NSString*)mobile callback:(ApiRequestCallBack)callback;
@end
