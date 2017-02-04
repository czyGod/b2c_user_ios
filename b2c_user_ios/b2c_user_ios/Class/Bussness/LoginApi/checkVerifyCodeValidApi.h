//
//  checkVerifyCodeValidApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface checkVerifyCodeValidApi : BaseApi
/**
 * 判断验证码是否有效 artist.user.checkVerifyCodeValid
 */

- (void)getCheckVerifyCodeValid:(NSString*)verifyCode mobile:(NSString*)mobile callback:(ApiRequestCallBack)callback;
@end
