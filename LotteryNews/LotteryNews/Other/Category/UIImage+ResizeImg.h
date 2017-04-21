//
//  UIImage+ResizeImg.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/23.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeImg)
+ (UIImage *)imageWithName:(NSString *)name;
+ (UIImage *)resizedImage:(NSString *)name;
+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
@end
