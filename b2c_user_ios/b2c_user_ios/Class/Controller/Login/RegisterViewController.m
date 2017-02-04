//
//  RegisterViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "RegisterViewController.h"
#import "NavigationController.h"

#import "RegisterView.h"

#import "SendVerifyCodeApi.h"
#import "SignUpApi.h"
#import "SignInApi.h"

#import "Check.h"

#import "RegisterAgreementView.h"

@interface RegisterViewController ()

//注册
@property (nonatomic, strong) RegisterView *registerView;

@property (nonatomic, strong) NSTimer *timeInterval;
@property (nonatomic, assign) NSInteger timeCount;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"注册"];
    
    [self configRegisterView];
}

- (void)configRegisterView {

    B2CWeakSelf
    _registerView = [[RegisterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) registerBlock:^(RegisterButtonStateType stateType) {
        
        if (stateType == RegisterButtonStateTypeSendVerifyCode) {
            
            [weakSelf sendVerifyCode];
        }else if (stateType == RegisterButtonStateTypeUserProtocol) {
        
            [weakSelf getIntoUserProtocol];
        }else if (stateType == RegisterButtonStateTypeRegister) {
        
            [weakSelf userRegister];
        }
        
    }];
    
    [self.view addSubview:_registerView];
}

#pragma mark - Private
- (void)sendVerifyCode {

    [self.view endEditing:YES];
    
    NSString *mobile = _registerView.phoneNumberTF.text;
    //验证手机号
    NSString *promptStr = [Check checkMobileNum:mobile];
    
    if (promptStr.length > 0) {
        
        [self showTextOnly:promptStr];
        return;
    }
    
    SendVerifyCodeApi *sendVerifyCodeApi = [[SendVerifyCodeApi alloc] init];
    [self  showIndicatorOnWindowWithMessage:@"发送中..."];
    [sendVerifyCodeApi userSendVerifyCodeWithMobile:mobile callback:^(id resultData, NSInteger code) {
        [self hideIndicatorOnWindow];
        if (code == 0) {
         
            [self showTextOnly:resultData];
            
            [self startCountDown];
        }
        else {
            
            [self showErrorMsg:resultData[@"error_msg"]];
        }
        
    }];
}


- (void)userAutoLogin {

    [self.view endEditing:YES];
    
    NSString *mobile = _registerView.phoneNumberTF.text;
    NSString *password = [HttpSign doMD5:_registerView.passwordTF.text];

    SignInApi *signInApi = [[SignInApi alloc] init];
    [signInApi getArtistUserSigninMobile:mobile password:password jpushRegId:[Singleton sharedManager].registrationID  callback:^(id resultData, NSInteger code) {
       
        if (code == 0) {
            
            /*: UserSigninApi 内部实现功能
             *  1.保存用户信息
             *  2.建立socket链接
             *  3.上传DeviceToken
             *  4.设置登陆成功
             */
      
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            
            [self showTextOnly:@"注册成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    
}


- (void)getIntoUserProtocol {
    
    RegisterAgreementView *agreementView = [[RegisterAgreementView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[UIApplication sharedApplication].windows.lastObject addSubview:agreementView];
}

- (void)userRegister {

    [self.view endEditing:YES];
    

    NSString *mobile = _registerView.phoneNumberTF.text;
    NSString *verifyCode = _registerView.verifyCodeTF.text;
    NSString *password = _registerView.passwordTF.text;
    
    NSString *errorMsg = @"";
    if (mobile.length != 11) {
        errorMsg = @"请输入正确的手机号";
    }
    else if (verifyCode.length != 6) {
        errorMsg = @"请输入正确的验证码";
    }
    else if (password.length == 0) {
        errorMsg = @"请填写密码";
    }
    if (errorMsg.length > 0) {
        
        [self showTextOnly:errorMsg];
        return;
    }
    
    SignUpApi *signUpApi = [[SignUpApi alloc] init];
   // [self showIndicatorOnWindowWithMessage:@"疯狂注册中..."];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [signUpApi userSignupMobile:mobile password:[HttpSign doMD5:password] verifyCode:verifyCode Callback:^(id resultData, NSInteger code) {
     //   [self hideIndicatorOnWindow];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (code == 0) {
            
            // [self userAutoLogin];
            [self showTextOnly:@"注册成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else {
            
            [self showErrorMsg:resultData[@"error_msg"]];
        }
    }];
}


#pragma mark - down count
- (void)startCountDown {
    
    _timeCount = 59;
    [_registerView.sendVerifyCodeButton setEnabled:NO];
    _timeInterval = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    
    if (_timeCount < 0) {
        
        [_timeInterval invalidate];
        _timeInterval = nil;
        _registerView.sendVerifyCodeButton.enabled = YES;
        [_registerView.sendVerifyCodeButton setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        return;
    }
    [_registerView.sendVerifyCodeButton setTitle:[NSString stringWithFormat:@"已发送(%lis)", _timeCount] forState:UIControlStateDisabled];
    _timeCount--;
}

@end
