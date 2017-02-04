//
//  UploadImageApi.m
//  ZhiYou
//
//  Created by 崔露凯 on 15/11/24.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "UploadImageApi.h"

@implementation UploadImageApi

- (void)uploadImageWithData:(NSData *)imageData callback:(ApiRequestCallBack)callback {
    if (imageData == nil) {
        return;
    }
    
    HttpRequestTool *adapter = [HttpRequestTool shareManage];
    [adapter asynPostUploadWithUrl:[Singleton sharedManager].httpImageServiceSubmitDomain  apiMethod:@"" parameters:nil fileData:imageData success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 0) {
            callback(PASS_NULL_TO_NIL(responseObj[@"file_path"]), 0);
        }
        else {
            callback(responseObj, 1);
        }
    } failure:^(NSError *error) {
        callback(nil, 1);
    }];
}


@end
