//
//  LoginViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

#import "LoginView.h"

#import "HomeViewController.h"

#import "AppDelegate.h"
#import "NavigationController.h"

#import "UserDefaultsUtil.h"

#import "SignInApi.h"
//#import "GetUserInfoApi.h"


@interface LoginViewController ()
//登录
@property (nonatomic, strong) LoginView *loginView;
//顶部视图
@property (nonatomic, strong) UIView *topView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"登录"];
    
    [UIBarButtonItem addLeftItemWithImageName:@"close_ic" frame:CGRectMake(0, 0, 16, 16) vc:self action:@selector(back)];
    
    [self configLoginView];
}

- (void)configLoginView {

    B2CWeakSelf;
    _loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) loginBlock:^(ButtonStateType stateType) {
        
        if (stateType == ButtonStateTypeLogin) {
            
            [weakSelf userLogin];
            
        }else if (stateType == ButtonStateTypeRegister) {
        
            RegisterViewController *registerVC = [[RegisterViewController alloc] init];
            
            [weakSelf.navigationController pushViewController:registerVC animated:YES];

            
        }else if (stateType == ButtonStateTypeForgetPassword) {
        
            ForgetPasswordViewController *forgetPwdVC = [ForgetPasswordViewController new];
            
            [weakSelf.navigationController pushViewController:forgetPwdVC animated:YES];
        }
        
    }];
    
    [self.view addSubview:_loginView];
}

#pragma mark - Private
- (void)userLogin {

    [self.view endEditing:YES];
    
    
    NSString *mobile = _loginView.userNameTF.text;
    NSString *password = [HttpSign doMD5:_loginView.passwordTF.text];
    NSString *errorMsg = @"";
    if (mobile.length != 11) {
        errorMsg = @"请输入正确的手机号";
    }
    else if (password.length == 0) {
        errorMsg = @"请填写密码";
    }
    if (errorMsg.length > 0) {

        [self showTextOnly:errorMsg];
        return;
    }
    self.view.userInteractionEnabled = NO;

    [self showIndicatorOnWindowWithMessage:@"登陆中"];
    SignInApi *signInApi = [[SignInApi alloc] init];
    
    [signInApi getArtistUserSigninMobile:mobile password:password jpushRegId:[Singleton sharedManager].registrationID callback:^(id resultData, NSInteger code) {
        [self hideIndicatorOnWindow];
        if (code == 0) {

            // 1、进入首页： 延时 0.5s执行获取用户信息, 否则alertView弹出有bug
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.view.userInteractionEnabled = YES;

                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                if (appDelegate.window.rootViewController.childViewControllers[0] == self) {
                    
                    [self gotoMain];
                }
                else {
                    
                    if (_loginSuccess) {
                        _loginSuccess();
                    }
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            });
            
        }
        else {
            self.view.userInteractionEnabled = YES;
            [self showErrorMsg:resultData[@"error_msg"]];
        }
    }];
    
}

- (void)getUserInfo {
    
 
}

- (void)gotoMain {

    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    
    NavigationController *navCtrl = [[NavigationController alloc] initWithRootViewController:homeVC];
    
    appDelegate.window.rootViewController = navCtrl;
}


#pragma mark - Event
- (void)back {

    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
   
}

@end
