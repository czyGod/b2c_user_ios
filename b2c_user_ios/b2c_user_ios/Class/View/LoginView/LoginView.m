//
//  LoginView.m
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "LoginView.h"
#import "UserDefaultsUtil.h"


@interface LoginView ()<UITextFieldDelegate>

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame loginBlock:(LoginBlock)loginBlock {

    if (self = [super initWithFrame:frame]) {
        
        _loginBlock = [loginBlock copy];
        
        
        [self configLoginView];
        
        self.backgroundColor = kPaleGreyColor;
    }

    return self;
}

- (void)configLoginView {

    UIView *userView = [[UIView alloc] init];
    
    userView.layer.cornerRadius = 6;
    userView.backgroundColor = kWhiteColor;
    //用户名
    _userNameTF = [[UITextField alloc] init];
    _userNameTF.placeholder = @"请输入账号";
    _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    _userNameTF.font = Font(13.0);
    _userNameTF.layer.cornerRadius = 6;
    _userNameTF.delegate = self;
    _userNameTF.tag = 1700;
    
    [userView addSubview:_userNameTF];
    
    [_userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(19);
    }];
    
    
    UIView *passwordView = [[UIView alloc] init];
    
    passwordView.layer.cornerRadius = 6;
    passwordView.backgroundColor = kWhiteColor;
    //密码
    _passwordTF = [[UITextField alloc] init];
    _passwordTF.placeholder = @"请输入密码";
    _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.font = Font(13.0);
    _passwordTF.layer.cornerRadius = 6;

    _passwordTF.delegate = self;
    
    [passwordView addSubview:_passwordTF];
    
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    [self addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(userView.mas_bottom).mas_equalTo(10);
    }];
    
    //提示标签
    UILabel *promptLabel = [[UILabel alloc] init];
    
    promptLabel.textColor = kDarkGreyColor;
    promptLabel.font = Font(11.0);
    promptLabel.text = @"没有账号？去";
    [self addSubview:promptLabel];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_passwordTF.mas_bottom).mas_equalTo(12.5);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_lessThanOrEqualTo(30);
        make.left.mas_equalTo(17);
    }];
    
    //注册
    UIButton *registerButton = [UIButton buttonWithTitle:@"注册" titleColor:kPaleBlueColor backgroundColor:nil titleFont:11.0];
    
    registerButton.tag = 2330 + 0;
    [registerButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:registerButton];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(promptLabel.mas_right).mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(40);
        make.height.mas_lessThanOrEqualTo(30);
        make.top.mas_equalTo(_passwordTF.mas_bottom).mas_equalTo(6);
    }];
    
    //忘记密码
    UIButton *forgetPasswordButton = [UIButton buttonWithTitle:@"忘记密码" titleColor:kPaleBlueColor backgroundColor:nil titleFont:11.0];
    
    forgetPasswordButton.tag = 2330 + 1;
    [forgetPasswordButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:forgetPasswordButton];
    
    [forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-17);
        make.width.mas_lessThanOrEqualTo(60);
        make.height.mas_lessThanOrEqualTo(30);
        make.top.mas_equalTo(_passwordTF.mas_bottom).mas_equalTo(6);
    }];
    
    //登录
    UIButton *loginButton = [UIButton buttonWithTitle:@"登录" titleColor:kDarkGreenColor backgroundColor:kWhiteColor titleFont:14.0 cornerRadius:6];
    
    loginButton.layer.borderWidth = 1;
    loginButton.layer.borderColor = kDarkGreenColor.CGColor;
    
    loginButton.tag = 2330 + 2;
    [loginButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.height.mas_lessThanOrEqualTo(43);
        make.top.mas_equalTo(_passwordTF.mas_bottom).mas_equalTo(65);
    }];

    
    // 获取默认手机号和密码
    NSString *mobile = [UserDefaultsUtil getUserDefaultName];
    if (mobile.length == 0) {
        return;
    }
    
    _userNameTF.text = mobile;
//    NSString *password = [UserDefaultsUtil getUserDefaultPassword];
//    if (password.length > 0) {
//        _passwordTF.text = @"存在用户密码";
//    }
    
}


- (void)clickButton:(UIButton *)button {

    NSUInteger tag = button.tag - 2330;
    
    if (tag == 0) {
        
        _loginBlock(ButtonStateTypeRegister);
        
    }else if (tag == 1) {
    
        
        _loginBlock(ButtonStateTypeForgetPassword);
        
    }else if (tag == 2) {
    
        _loginBlock(ButtonStateTypeLogin);
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_passwordTF resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {
        return YES;
    }
    if (textField.tag == 1700) {
        
        if (textField.text.length >= 11) {
            
            return NO;
        }
    }
    
    return YES;
}

@end
