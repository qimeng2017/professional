//
//  UIImage+ResizeImg.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/23.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "UIImage+ResizeImg.h"

@implementation UIImage (ResizeImg)
+ (UIImage *)imageWithName:(NSString *)name
{
    return [self imageNamed:name];
}

+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImage:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
@end
