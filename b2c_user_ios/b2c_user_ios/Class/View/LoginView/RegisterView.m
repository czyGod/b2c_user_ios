//
//  RegisterView.m
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "RegisterView.h"
#import "AppMacro.h"

@interface RegisterView ()<UITextFieldDelegate>

@end

@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame registerBlock:(RegisterBlock)registerBlock {

    if (self = [super initWithFrame:frame]) {
        
        _registerBlock = [registerBlock copy];
        
        
        [self configRegisterView];
        
        self.backgroundColor = kPaleGreyColor;
    }
    
    return self;

}

- (void)configRegisterView {

    UIView *mobileView = [[UIView alloc] init];
    
    mobileView.layer.cornerRadius = 6;
    mobileView.backgroundColor = kWhiteColor;
    
    //手机号
    _phoneNumberTF = [[UITextField alloc] init];
    _phoneNumberTF.placeholder = @"请输入手机号";
    _phoneNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumberTF.font = Font(13.0);
    _phoneNumberTF.layer.cornerRadius = 6;
    _phoneNumberTF.delegate = self;
    _phoneNumberTF.tag = 1750;
    
    [mobileView addSubview:_phoneNumberTF];
    
    [_phoneNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:mobileView];
    [mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(19);
    }];

    //发送验证码
    _sendVerifyCodeButton = [UIButton buttonWithTitle:@"发送验证码" titleColor:kDarkGreyColor backgroundColor:kWhiteColor titleFont:14.0];
    
    _sendVerifyCodeButton.layer.cornerRadius = 6;
    _sendVerifyCodeButton.tag = 2340 + 0;
    
    [_sendVerifyCodeButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_sendVerifyCodeButton];
    
    [_sendVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(kWidth(110));
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(mobileView.mas_bottom).mas_equalTo(10);
    }];
    
    UIView *verifyCodeView = [[UIView alloc] init];
    
    verifyCodeView.backgroundColor = kWhiteColor;
    verifyCodeView.layer.cornerRadius = 6;
    //验证码
    _verifyCodeTF = [[UITextField alloc] init];
    _verifyCodeTF.placeholder = @"请输入验证码";
    _verifyCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _verifyCodeTF.font = Font(13.0);
    _verifyCodeTF.layer.cornerRadius = 6;
    _verifyCodeTF.delegate = self;
    _verifyCodeTF.tag = 1760;
    _verifyCodeTF.backgroundColor = kWhiteColor;

    [verifyCodeView addSubview:_verifyCodeTF];
    
    [_verifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    [self addSubview:verifyCodeView];
    [verifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(_sendVerifyCodeButton.mas_left).mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(mobileView.mas_bottom).mas_equalTo(10);
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
        make.top.mas_equalTo(verifyCodeView.mas_bottom).mas_equalTo(10);
    }];

    //提示标签
    UILabel *promptLabel = [[UILabel alloc] init];
    
    promptLabel.textColor = kDarkGreyColor;
    promptLabel.font = Font(11.0);
    promptLabel.text = @"注册即代表同意";
    [self addSubview:promptLabel];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(passwordView.mas_bottom).mas_equalTo(12);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_lessThanOrEqualTo(30);
        make.left.mas_equalTo(17);
    }];
    
    //用户协议
    UIButton *userProtocolButton = [UIButton buttonWithTitle:@"《用户使用条款及服务协议》" titleColor:kPaleBlueColor backgroundColor:nil titleFont:11.0];
    [userProtocolButton setEnlargeEdge:20];
    userProtocolButton.tag = 2340 + 1;
    [userProtocolButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:userProtocolButton];
    
    [userProtocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(promptLabel.mas_right).mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(150);
        make.height.mas_lessThanOrEqualTo(30);
        make.top.mas_equalTo(_passwordTF.mas_bottom).mas_equalTo(8);
    }];

    //注册
    UIButton *registerButton = [UIButton buttonWithTitle:@"注册" titleColor:kDarkGreenColor backgroundColor:kWhiteColor titleFont:14.0 cornerRadius:6];
    
    registerButton.layer.borderWidth = 1;
    registerButton.layer.borderColor = kDarkGreenColor.CGColor;
    
    registerButton.tag = 2340 + 2;
    [registerButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:registerButton];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.height.mas_lessThanOrEqualTo(43);
        make.top.mas_equalTo(_passwordTF.mas_bottom).mas_equalTo(60);
    }];
}

- (void)clickButton:(UIButton *)button {

    NSUInteger tag = button.tag - 2340;
    
    if (tag == 0) {
        
        _registerBlock(RegisterButtonStateTypeSendVerifyCode);
        
    }else if (tag == 1) {
    
        _registerBlock(RegisterButtonStateTypeUserProtocol);
    
    }else if (tag == 2) {
    
        _registerBlock(RegisterButtonStateTypeRegister);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_passwordTF resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {//按下return
        return YES;
    }
    if (textField.tag == 1750) {
        
        if (textField.text.length >= 11) {
            
            return NO;
        }
        
    }else if (textField.tag == 1760) {
    
        if (textField.text.length >= 6) {
            
            return NO;
        }
    }
    
    return YES;
}

@end
