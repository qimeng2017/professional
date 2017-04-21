//
//  CoverViewController.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/3/6.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^showFinishBlock)();
@interface CoverViewController : UIViewController

- (instancetype)initWithFrame:(CGRect)frame showFinish:(showFinishBlock)showFinish;
@end
