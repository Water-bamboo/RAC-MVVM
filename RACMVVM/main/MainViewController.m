//
//  MainViewController.m
//  RACMVVM
//
//  Created by 林水竹 on 22/10/2017.
//  Copyright © 2017 Shuizhu. All rights reserved.
//

#import "MainViewController.h"
#import "MVVMViewController.h"
#import "RACCommandTestViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginWithRACDemo:(id)sender {
    LoginViewController *loginRAC2VC = [LoginViewController new];
    [self.navigationController pushViewController:loginRAC2VC animated:NO];
}


- (IBAction)openLogin:(id)sender {
    MVVMViewController *mvvmVC = [[MVVMViewController alloc] init];
    [self.navigationController pushViewController:mvvmVC animated:YES];
}

- (IBAction)racCommand:(id)sender {
    RACCommandTestViewController *racCommandVC = [RACCommandTestViewController new];
    [self.navigationController pushViewController:racCommandVC animated:YES];
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
