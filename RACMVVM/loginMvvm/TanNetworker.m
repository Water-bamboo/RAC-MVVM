//
//  TanNetworker.m
//  RACMVVM
//
//  Created by Shui on 2017/10/15.
//  Copyright © 2017年 Shuizhu. All rights reserved.
//

#import "TanNetworker.h"

@implementation TanNetworker

+ (RACSignal *)loginWithUserName:(NSString *) name password:(NSString *)password
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //Assume the network command is done after 3 second.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:[NSString stringWithFormat:@"User %@, password %@, login!", name, password]];
            NSLog(@"准备结束了");
            [subscriber sendCompleted];
        });
        return nil;
    }];
}

@end
