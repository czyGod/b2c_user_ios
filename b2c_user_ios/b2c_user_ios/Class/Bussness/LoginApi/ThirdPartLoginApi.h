//
//  ThirdPartLoginApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface ThirdPartLoginApi : BaseApi
/**
 *  第三方登录 artist.user.thirdPartLogin
 */

- (void)getThirdPartLoginType:(NSInteger)type uId:(NSString*)uId nickname:(NSString*)naickname headimgul:(NSString*)headimgurl callback:(ApiRequestCallBack)callback;

@end
