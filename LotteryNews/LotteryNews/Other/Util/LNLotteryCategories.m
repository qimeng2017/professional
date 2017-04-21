//
//  LNLotteryCategories.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "LNLotteryCategories.h"

@implementation LNLotteryCategories
+ (LNLotteryCategories *)sharedInstance
{
    static LNLotteryCategories *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LNLotteryCategories alloc] init];
    });
    
    return _sharedInstance;
}
@end
