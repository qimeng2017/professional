//
//  NSString+Base64.h
//  Lottery
//
//  Created by 邹壮壮 on 2016/12/19.
//  Copyright © 2016年 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)
/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;
@end
