//
//  JenkinsConfig.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 17/1/23.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "JenkinsConfig.h"





@implementation JenkinsConfig



+ (NSString*)getValueForKey:(NSString*)key {

    static dispatch_once_t token;
    static NSDictionary *dateSource = nil;
    dispatch_once(&token, ^{
       
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JenkinsPlist.plist" ofType:nil];
        dateSource = [NSDictionary dictionaryWithContentsOfFile:filePath];
    });
    
    
    NSString *value = dateSource[key];

    return PASS_NULL_TO_NIL(value) ? value: nil;
}




@end
