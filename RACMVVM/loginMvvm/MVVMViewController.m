//
//  MVVMViewController.m
//  RACMVVM
//
//  Created by Shui on 2017/10/15.
//  Copyright © 2017年 Shuizhu. All rights reserved.
//

//an example of Login.
#import "MVVMViewController.h"
#import "TanLoginViewModel.h"


@interface MVVMViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *juhuaView;
@property (strong, nonatomic) TanLoginViewModel *viewModel;


@end

@implementation MVVMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.juhuaView.hidden = YES;
    _viewModel = [[TanLoginViewModel alloc]init];
    [self.userNameTF addTarget:self action:@selector(usernameChanged:) forControlEvents:UIControlEventEditingChanged];

    @weakify(self)
    RAC(self.viewModel, userName) = self.userNameTF.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTF.rac_textSignal;
    
    NSLog(@"loginBtn.rac_command=%@", self.loginBtn.rac_command);
    
    self.loginBtn.rac_command = self.viewModel.loginCommand;
    [[self.viewModel.loginCommand executionSignals]
     subscribeNext:^(RACSignal *x) {
         @strongify(self)
         self.juhuaView.hidden = NO;
         [x subscribeNext:^(NSString *x) {
             self.juhuaView.hidden = YES;
             NSLog(@"结束了：》》》》》》》》》》%@",x);
         }];
     }];
}

- (void) usernameChanged:(UITextField *)sender
{
    self.viewModel.userName = sender.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
