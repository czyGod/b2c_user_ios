//
//  SetPasswordApi.h
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "BaseApi.h"

@interface SetPasswordApi : BaseApi
/**
 *   修改密码(merchant.user.setPassword)
 */

- (void)getSetPasswordOldPassword:(NSString*)oldPassword password:(NSString*)password callback:(ApiRequestCallBack)callback;
@end
