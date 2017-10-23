//
//  MetaProgramViewController.m
//  RACMVVM
//
//  Created by 林水竹 on 23/10/2017.
//  Copyright © 2017 Shuizhu. All rights reserved.
//

#import "MetaProgramViewController.h"
#import <ReactiveCocoa.h>

@interface MetaProgramViewController ()

@end

@implementation MetaProgramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int argcount = metamacro_argcount(1,2,3,3);
    int argcount2 = metamacro_argcount(1,"2","",3,3,asdf);
    
//#define metamacro_at(N, ...) metamacro_concat(metamacro_at, N)(__VA_ARGS__)

    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(0, 20+44+8, self.view.frame.size.width, 200);
    [self.view addSubview:textView];
    
    NSMutableString *textString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"argument count:metamacro_argcount(1,2,3,3)=%d", argcount]];
    [textString appendString:[NSString stringWithFormat:@"\n\nargument count:metamacro_argcount(1,'2','',3,3,asdf)=%d", argcount2]];
    //
    int concatResult = metamacro_concat(11, 1);
    [textString appendString:[NSString stringWithFormat:@"\n\nmetamacro_concat(11, 22)=%d", concatResult]];
    
    [textString appendString:[NSString stringWithFormat:@"\n\nmetamacro_at(6,12,3,4,0)=%d", metamacro_at4(6,12,3,4,0)]];
    [textString appendString:[NSString stringWithFormat:@"\n\nmetamacro_at(6,12,3,4,3)=%d", metamacro_at4(6,12,3,4,3)]];
//    Use of undeclared identifier 'metamacro_if_eq0_1'
//    [textString appendString:[NSString stringWithFormat:@"\n\nmetamacro_if_eq(6,6)=%d", metamacro_if_eq(1,2)]];
//    [textString appendString:[NSString stringWithFormat:@"\n\nmetamacro_if_eq(1,2)=%d", metamacro_if_eq(1,2)]];
    textView.text = textString;
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
