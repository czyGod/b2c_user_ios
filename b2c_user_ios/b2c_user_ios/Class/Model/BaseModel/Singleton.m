//
//  Singleton.m
//  AFNetworkingTool
//
//  Created by 崔露凯 on 15/11/15.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "Singleton.h"
#import "UserDefaultsUtil.h"

@implementation Singleton

+ (Singleton *)sharedManager {
    
    static Singleton *g_singleton = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        g_singleton = [[super alloc] init];
    });
    return g_singleton;
}

- (NSString *)phpSesionId {
    
    if (_phpSesionId == nil || [_phpSesionId isEqualToString:@""]) {
        NSString *cookie = [UserDefaultsUtil getUsetDefaultCookie];
        if (cookie) {
            _phpSesionId = cookie;
        }
        else {
            _phpSesionId = @"";
        }
    }
    return _phpSesionId;
}

@end
