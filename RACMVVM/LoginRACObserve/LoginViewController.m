//
//  LoginViewController.m
//  RACMVVM
//
//  Created by Shui on 2017/10/13.
//  Copyright © 2017年 Shuizhu. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self
    
    UIView *loginPanel = [[UIView alloc] init];
    [self.view addSubview:loginPanel];
    loginPanel.backgroundColor = [UIColor lightGrayColor];
    [loginPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(20+44);
        make.height.equalTo(@300);
    }];

    //username
    UITextField *userNameTextField = [[UITextField alloc] init];
    userNameTextField.placeholder = @"   User name.";
    [loginPanel addSubview:userNameTextField];
    userNameTextField.layer.borderColor = [UIColor blueColor].CGColor;
    userNameTextField.layer.cornerRadius = 3;
    userNameTextField.layer.borderWidth = 1;
    [[userNameTextField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        UITextField *tf = (UITextField *)x;
        NSLog(@"------%@", tf.text);
    }];

    [userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(loginPanel);
        make.size.mas_equalTo(CGSizeMake(250, 50));
    }];
    //password
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.placeholder = @"Please input password.";
    [loginPanel addSubview:passwordTextField];
    passwordTextField.layer.borderColor = [UIColor blueColor].CGColor;
    passwordTextField.layer.borderWidth = 2;
    passwordTextField.layer.cornerRadius = 10;
    [[passwordTextField rac_textSignal] subscribeNext:^(id x) {
//        NSLog(@"passwordTextField--->%@", x);
    }];

    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(userNameTextField);
        make.top.mas_equalTo(userNameTextField.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(250, 50));
    }];
    _passwordTextField = passwordTextField;
    
    //submit
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginPanel addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(passwordTextField);
        make.top.mas_equalTo(passwordTextField.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 50));
    }];
    
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [[submit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"---提交---");
        
    }];

//    Unknown warning group '-Wreceiver-is-weak', ignored
//    RACSignal
//    RACSubject

    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id x) {
        NSLog(@"---收到一个偶数：%@---", x);
    }];

    @weakify(subject)
    [[RACObserve(passwordTextField, text) filter:^BOOL(id value) {
        return [value integerValue] > 10;
    }] subscribeNext:^(id x) {
        @strongify(subject)
        NSLog(@"password is changed: x=%@", x);
        if ([x integerValue] % 2 == 0) {
            [subject sendNext:x];
        }
    }];

    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(setRandomValueToPasswordField) userInfo:@{@"data":@3} repeats:YES];
}


- (void) setRandomValueToPasswordField
{
    self.passwordTextField.text = [NSString stringWithFormat:@"%d", arc4random_uniform(20)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
