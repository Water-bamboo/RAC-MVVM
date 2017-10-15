//
//  TanLoginViewModel.m
//  RACMVVM
//
//  Created by Shui on 2017/10/15.
//  Copyright © 2017年 Shuizhu. All rights reserved.
//

#import "TanLoginViewModel.h"
#import "TanNetworker.h"

@implementation TanLoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        RACSignal *userNameLengthSig = [RACObserve(self, userName)
                                        map:^id(NSString *value) {
                                            if (value.length > 6) return @(YES);
                                            return @(NO);
                                        }];
        RACSignal *passwordLengthSig = [RACObserve(self, password)
                                        map:^id(NSString *value) {
                                            if (value.length > 6) return @(YES);
                                            return @(NO);
                                        }];
        RACSignal *loginBtnEnable = [RACSignal combineLatest:@[userNameLengthSig, passwordLengthSig] reduce:^id(NSNumber *userName, NSNumber *password){
            return @([userName boolValue] && [password boolValue]);
        }];

        
        _loginCommand = [[RACCommand alloc] initWithEnabled:loginBtnEnable signalBlock:^RACSignal *(id input) {
            return [TanNetworker loginWithUserName:self.userName password:self.password];
        }];
        
    }
    return self;
}
    
@end
