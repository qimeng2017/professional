//
//  ProgressHUD.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressHUD : NSObject
+ (ProgressHUD *)sharedInstance;
- (void)show;
- (void)showProgress:(CGFloat)pfloat message:(NSString *)message;
- (void)showWithStatus:(NSString *)message;
- (void)showInfoWithStatus:(NSString *)message;
- (void)showErrorOrSucessWithStatus:(BOOL)isError message:(NSString *)message;
@end
