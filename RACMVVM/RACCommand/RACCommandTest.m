//
//  RACCommandTest.m
//  RACMVVM
//
//  Created by Shui on 2017/10/15.
//  Copyright © 2017年 Shuizhu. All rights reserved.
//

#import "RACCommandTest.h"
#import <ReactiveCocoa.h>

@implementation RACCommandTest

// 普通做法
- (void)test1 {
    // RACCommand: 处理事件
    // 不能返回空的信号
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //block调用，执行命令的时候就会调用
        NSLog(@"有人执行了。。。INPUT=%@",input); // input 为执行命令传进来的参数
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"在这里做很复杂，很耗时的事情");
            [subscriber sendNext:@"执行命令完毕。结果数据sendNext."];
            return nil;
        }];
    }];

    // 如何拿到执行命令中产生的数据呢？
    // 订阅命令内部的信号
    // ** 方式一：直接订阅执行命令返回的信号
    
    // 2.执行命令
    RACSignal *signal = [command execute:@2]; // 这里其实用到的是replaySubject 可以先发送命令再订阅
    // 在这里就可以订阅信号了
    [signal subscribeNext:^(id x) {
        NSLog(@">>%@",x);
    }];
}

// 一般做法
- (void)test2 {
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //block调用，执行命令的时候就会调用
        NSLog(@"接收到信号：input=%@",input); // input 为执行命令传进来的参数
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行完毕！命令产生的数据>>发给订阅者"];
            return nil;
        }];
    }];
    
    // 方式二：
    // 订阅信号
    // 注意：这里必须是先订阅才能发送命令
    // executionSignals：信号源，信号中信号，signalofsignals:信号，发送数据就是信号
    [command.executionSignals subscribeNext:^(RACSignal *x) {
        NSLog(@"准备执行信号了>>");
        [x subscribeNext:^(id x) {
            NSLog(@"收到：%@", x);
        }];
        //        NSLog(@"%@", x);
    }];
    
    // 2.执行命令
    [command execute:@2];
}

// 高级做法
- (void)test3 {
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        NSLog(@"%@", input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"发送信号"];
            return nil;
        }];
    }];
    
    // 方式三
    // switchToLatest获取最新发送的信号，只能用于信号中信号。
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 2.执行命令
    [command execute:@3];
    
}

// switchToLatest
- (void)test4 {
    // 创建信号中信号
    RACSubject *signalofsignals = [RACSubject subject];
    RACSubject *signalA = [RACSubject subject];
    // 订阅信号
    //    [signalofsignals subscribeNext:^(RACSignal *x) {
    //        [x subscribeNext:^(id x) {
    //            NSLog(@"%@", x);
    //        }];
    //    }];
    // switchToLatest: 获取信号中信号发送的最新信号
    [signalofsignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [signalofsignals sendNext:signalA];
    [signalA sendNext:@4];
}

/*
 RACCommand 通常用来表示某个Action的执行，比如点击Button。它有几个比较重要的属性：executionSignals / errors / executing。
 
 1、executionSignals是signal of signals，如果直接subscribe的话会得到一个signal，而不是我们想要的value，所以一般会配合switchToLatest。
 
 2、errors。跟正常的signal不一样，RACCommand的错误不是通过sendError来实现的，而是通过errors属性传递出来的。
 
 3、executing表示该command当前是否正在执行。
 */


// 监听事件有没有完成
- (void)test5 {
    //注意：当前命令内部发送数据完成，一定要主动发送完成
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        NSLog(@"%@", input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            
            // *** 发送完成 **
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    // 监听事件有没有完成
    [command.executing subscribeNext:^(id x) {
        if ([x boolValue] == YES) { // 正在执行
            NSLog(@"当前正在执行%@", x);
        }else {
            // 执行完成/没有执行
            NSLog(@"执行完成/没有执行");
        }
    }];
    
    // 2.执行命令
    [command execute:@1];
    
}

@end
