//
//  RACCommandTestViewController.m
//  RACMVVM
//
//  Created by 林水竹 on 22/10/2017.
//  Copyright © 2017 Shuizhu. All rights reserved.
//

#import "RACCommandTestViewController.h"
#import "RACCommandTest.h"

@interface RACCommandTestViewController ()

@end

@implementation RACCommandTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton *uibutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [uibutton setTitle:@"发送command" forState:UIControlStateNormal];
    uibutton.tintColor = [UIColor blackColor];
    [uibutton sizeToFit];
    CGRect frame = uibutton.frame;
    frame.origin.y = 20+44+10;
    uibutton.frame = frame;
    [uibutton addTarget:self action:@selector(sendCommand:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uibutton];
}

- (void) sendCommand:(id)sender
{
    RACCommandTest *racCmd = [[RACCommandTest alloc] init];
    [racCmd test2];
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
