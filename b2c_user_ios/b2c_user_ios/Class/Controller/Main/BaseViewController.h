//
//  BaseViewController.h
//  BS
//
//  Created by 崔露凯 on 16/3/31.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UIAlertViewDelegate>


- (void)showIndicatorOnWindow;

- (void)showIndicatorOnWindowWithMessage:(NSString *)message;

- (void)showTextOnly:(NSString *)text;

- (void)showErrorMsg:(NSString*)text;

- (void)hideIndicatorOnWindow;

- (void)showReLoginAlert;

- (void)showReLoginVC;

- (BOOL)isLogin;

- (void)dismissReLoginVC;


@end
