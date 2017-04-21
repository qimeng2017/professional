//
//  ProgressHUD.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "ProgressHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>
@implementation ProgressHUD
+ (ProgressHUD *)sharedInstance
{
    static ProgressHUD *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ProgressHUD alloc] init];
    });
    
    return _sharedInstance;
}


- (void)show{
     [SVProgressHUD show];
    [self dismissWithDelay:2];
}
- (void)showProgress:(CGFloat)pfloat message:(NSString *)message{
    if (message.length <= 0||message== nil) {
        [SVProgressHUD showProgress:pfloat];
    }else{
      [SVProgressHUD showProgress:pfloat status:message];
    }
    [self dismissWithDelay:2];
}
- (void)showWithStatus:(NSString *)message{
    [SVProgressHUD showWithStatus:message];
    [self dismissWithDelay:2];
}
- (void)showInfoWithStatus:(NSString *)message{
    [SVProgressHUD showInfoWithStatus:message];
    [self dismissWithDelay:2];
}
- (void)showErrorOrSucessWithStatus:(BOOL)isError message:(NSString *)message{
    if (isError) {
        
       [SVProgressHUD showErrorWithStatus:message];
    }else{
      [SVProgressHUD showSuccessWithStatus:message];
    }
    [self dismissWithDelay:2];
}
- (void)dismissWithDelay:(NSTimeInterval)delay{
    [SVProgressHUD dismissWithDelay:delay];
}
@end
