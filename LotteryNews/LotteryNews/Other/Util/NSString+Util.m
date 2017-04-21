//
//  NSString+Util.m
//  Lottery
//
//  Created by quentin on 16/5/17.
//  Copyright © 2016年 Quentin. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

- (NSString *)lotterySue
{
    if (self.length > 4) {
        return [self substringFromIndex:4];
    }
    
    return self;
}

- (NSString *)calcNum
{
    return [self stringByReplacingOccurrencesOfString:@"," withString:@" "];
}

@end
