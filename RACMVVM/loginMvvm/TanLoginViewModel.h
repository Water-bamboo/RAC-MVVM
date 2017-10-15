//
//  TanLoginViewModel.h
//  RACMVVM
//
//  Created by Shui on 2017/10/15.
//  Copyright © 2017年 Shuizhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface TanLoginViewModel : NSObject

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, strong, readonly) RACCommand *loginCommand;

@end
