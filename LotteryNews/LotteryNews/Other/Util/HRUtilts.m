//
//  HRUtilts.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/24.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRUtilts.h"
#import "NSString+Base64.h"
@implementation HRUtilts
+ (HRUtilts *)sharedInstance
{
    static HRUtilts *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HRUtilts alloc] init];
    });
    
    return _sharedInstance;
}
- (NSString *)idfa{
    NSString*idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
   
}

- (NSString *)verify:(NSString *)date{
    NSString *idfa = [self idfa];
    NSString *redUrl = [NSString stringWithFormat:@"%@1384425865F069450EB8A517964CB040%@",idfa,date];
    NSString *verify = [NSString stringToMD5:redUrl];
    return verify;
}
@end
