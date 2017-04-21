//
//  UIColor+Extension.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) getColor:(NSString *)hexColor alpha:(CGFloat)alpha;
@end
