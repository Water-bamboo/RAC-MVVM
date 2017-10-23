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

//other rac test
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *passwordConfirmation;
@property (nonatomic, assign) BOOL createEnabled;

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

    
    //    Unknown warning group '-Wreceiver-is-weak', ignored
    //    RACSignal
    //    RACSubject
    
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id x) {
        NSLog(@"---收到一个偶数：%@---", x);
    }];
    //Unknown warning group '-Wreceiver-is-weak', ignored
    //    @weakify(subject)
    //写法1:
//    [[RACObserve(_passwordTF, text) filter:^BOOL(id value) {
//
//        return [value integerValue] > 10;
//    }] subscribeNext:^(id x) {
//        //        @strongify(subject)
//        NSLog(@"password is changed: x=%@", x);
//        if ([x integerValue] % 2 == 0) {
//            [subject sendNext:x];
//        }
//    }];
    
    //写法2:
    [[[_passwordTF rac_valuesForKeyPath:@"text" observer:nil] filter:^BOOL(id value) {
        
        return [value integerValue] > 10;
    }] subscribeNext:^(id x) {
        //        @strongify(subject)
        NSLog(@"password is changed: x=%@", x);
        if ([x integerValue] % 2 == 0) {
            [subject sendNext:x];
        }
    }];
    ;
    
    RAC(self, createEnabled) = [RACSignal
                                combineLatest:@[ RACObserve(self, password), RACObserve(self, passwordConfirmation) ]
                                reduce:^(NSString *password, NSString *passwordConfirm) {
                                    return @([passwordConfirm isEqualToString:password]);
                                }];
}

- (IBAction)racSignalTest:(id)sender {
    [self testConcat];
    [self testMerge];
    [self testCombine];
    [self testZip];
    [self testMap];
    [self testReduce];
    [self testFilter];
    [self testFlattenMap];
    [self testThen];
    [self testCommand];
    [self testDelay];
    [self testReplay];
    [self testInterval];
    [self testTakeUntil];
}

- (void) testConcat {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"我恋爱啦"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"我结婚啦"];
        [subscriber sendCompleted];
        return nil;
    }];
    [[signalA concat:signalB] subscribeNext:^(id x) {
        NSLog(@"testConcat:%@",x);
    }];
}

- (void) testMerge {
    //
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"纸厂污水"];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"电镀厂污水"];
        return nil;
    }];
    [[RACSignal merge:@[signalA, signalB]] subscribeNext:^(id x) {
        NSLog(@"testMerge:处理%@",x);
    }];
}

- (void) testCombine
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"红"];
        [subscriber sendNext:@"白"];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"白"];
        return nil;
    }];
    [[RACSignal combineLatest:@[signalA, signalB]] subscribeNext:^(RACTuple* x) {
        RACTupleUnpack(NSString *stringA, NSString *stringB) = x;
        NSLog(@"testCombineLatest:我们是%@%@的", stringA, stringB);
    }];
}

- (void) testZip
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"红"];
        [subscriber sendNext:@"白"];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"黑"];[subscriber sendNext:@"blue"];
        return nil;
    }];
    [[signalA zipWith:signalB] subscribeNext:^(RACTuple* x) {
        RACTupleUnpack(NSString *stringA, NSString *stringB) = x;
        NSLog(@"testZip:我们是%@%@的", stringA, stringB);
    }];
}

- (void) testMap
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"石"];
        [subscriber sendNext:@"沙"];
        return nil;
    }] map:^id(NSString* value) {
        if ([value isEqualToString:@"石"]) {
            return @"金";
        }
        return value;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"testMap:%@", x);
    }];
}

- (void) testReduce
{
    RACSignal *sugarSignal = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"糖"];
        return nil;
    }];
    RACSignal *waterSignal = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"水"];
        return nil;
    }];
    [[RACSignal combineLatest:@[sugarSignal, waterSignal] reduce:^id (NSString* sugar, NSString*water){
        return [sugar stringByAppendingString:water];
    }] subscribeNext:^(id x) {
        NSLog(@"testReduce:%@", x);
    }];
}

- (void) testFilter
{
    [[[RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@(15)];
        [subscriber sendNext:@(17)];
        [subscriber sendNext:@(21)];
        [subscriber sendNext:@(14)];
        [subscriber sendNext:@(30)];
        [subscriber sendCompleted];
        return nil;
    }] filter:^BOOL(NSNumber* value) {
        return value.integerValue >= 18;
    }] subscribeNext:^(id x) {
        NSLog(@"Next:%@", x);
    } completed:^{
        NSLog(@"Completed");
    }];
}

- (void) testFlattenMap
{
    [[[[RACSignal createSignal:^RACDisposable *(id subscriber) {
        NSLog(@"打蛋液");
        [subscriber sendNext:@"蛋液"];
        [subscriber sendCompleted];
        return nil;
    }] flattenMap:^RACStream *(NSString* value) {
        return [RACSignal createSignal:^RACDisposable *(id subscriber) {
            NSLog(@"把%@倒进锅里面煎",value);
            [subscriber sendNext:@"煎蛋"];
            [subscriber sendCompleted];
            return nil;
        }];
    }] flattenMap:^RACStream *(NSString* value) {
        return [RACSignal createSignal:^RACDisposable *(id subscriber) {
            NSLog(@"把%@装到盘里", value);
            [subscriber sendNext:@"上菜"];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void) testThen
{
    [[[[RACSignal createSignal:^RACDisposable *(id subscriber) {
        NSLog(@"打开冰箱门");
//        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id subscriber) {
            NSLog(@"把大象塞进冰箱");
            [subscriber sendCompleted];
            return nil;
        }];
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id subscriber) {
            NSLog(@"关上冰箱门");
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeCompleted:^{
        NSLog(@"把大象塞进冰箱了");
    }];
}

- (void) testCommand
{
    RACCommand *aCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id subscriber) {
            NSLog(@"我投降了");
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    [aCommand execute:nil];
}

- (void) testDelay
{
    [[[RACSignal createSignal:^RACDisposable *(id subscriber) {
        NSLog(@"等等我，我还有10秒钟就到了");
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }] delay:10] subscribeNext:^(id x) {
        NSLog(@"我到了");
    }];
}

- (void) testReplay
{
    RACSignal *replaySignal = [[RACSignal createSignal:^RACDisposable *(id subscriber) {
        NSLog(@"大导演拍了一部电影《我的男票是程序员》");
        [subscriber sendNext:@"《我的男票是程序员》"];
        return nil;
    }] replay];
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"小明看了%@", x);
    }];
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"小红也看了%@", x);
    }];
}

- (void) testInterval
{
    [[RACSignal interval:60*60*8 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"吃药");
    }];
}

//takeUntil如果发生了，就停止了主任务.
- (void) testTakeUntil
{
    [[[RACSignal createSignal:^RACDisposable *(id subscriber) {
        [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            [subscriber sendNext:[NSString stringWithFormat:@"直到世界的尽头才能把我们分开. subscriber=%@", subscriber]];
        }];
        return nil;
    }] takeUntil:[RACSignal createSignal:^RACDisposable *(id subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"世界的尽头到了");
            [subscriber sendNext:[NSString stringWithFormat:@"世界的尽头到了:subscriber=%@", subscriber]];
        });
        return nil;
    }]] subscribeNext:^(id x) {
        NSLog(@"》》》%@", x);
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
