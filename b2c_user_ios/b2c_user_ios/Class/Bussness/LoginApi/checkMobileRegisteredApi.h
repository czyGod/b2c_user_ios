//
//  checkMobileRegisteredApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface checkMobileRegisteredApi : BaseApi
/**
 *  验证手机号是否已经注册 artist.user.checkMobileRegistered
 */

- (void)getArtistUserCheckMobileRegisteredMobile:(NSString*)mobile callback:(ApiRequestCallBack)callback;
@end
