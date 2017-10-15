//
//  TanNetworker.h
//  RACMVVM
//
//  Created by Shui on 2017/10/15.
//  Copyright © 2017年 Shuizhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface TanNetworker : NSObject

+ (RACSignal *)loginWithUserName:(NSString *) name password:(NSString *)password;

@end
