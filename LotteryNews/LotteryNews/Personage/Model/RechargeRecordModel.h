//
//  RechargeRecordModel.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RechargeRecordModel : JSONModel
@property (nonatomic, strong)NSString *deal_number;
@property (nonatomic, strong)NSString *recharge_money;
@property (nonatomic, strong)NSString *recharge_gold;
@property (nonatomic, strong)NSString *recharge_status;
@property (nonatomic, strong)NSString *r_time;
@end
