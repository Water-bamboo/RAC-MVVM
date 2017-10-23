//
//  PragmaViewController.m
//  RACMVVM
//
//  Created by 林水竹 on 22/10/2017.
//  Copyright © 2017 Shuizhu. All rights reserved.
//

#import "PragmaViewController.h"

@interface PragmaViewController ()

@end

@implementation PragmaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    试试设置-Weverything标志，并在你的build setting里选择“Treat Warnings as Errors”。这将会开启Xcode的困难模式。
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    int x=10;
#pragma clang diagnostic pop
    
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
