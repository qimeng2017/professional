//
//  BuyRecordModel.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "BuyRecordModel.h"
#import "NSDate+Formatter.h"
#import "NSString+Util.h"
@implementation BuyRecordModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
- (NSString *)yc_content{
    return [_yc_content calcNum];
}
- (void)setB_time:(NSString *)b_time{
    if (b_time.length > 0) {
        double time = [b_time doubleValue];
        b_time = [NSDate timeStamp:time];
    }
    _b_time = b_time;
}

@end
