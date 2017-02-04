//
//  SignInApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface SignInApi : BaseApi
/**
 * 登录 artist.user.signin
 */

- (void)getArtistUserSigninMobile:(NSString*)mobile password:(NSString*)password jpushRegId:(NSString*)jpushRegId callback:(ApiRequestCallBack)callback;

@end
