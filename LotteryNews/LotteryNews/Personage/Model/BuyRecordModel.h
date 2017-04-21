//
//  BuyRecordModel.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BuyRecordModel : JSONModel
@property (nonatomic, strong)NSString *expert_name;
@property (nonatomic, strong)NSString *yc_content;
@property (nonatomic, strong)NSString *buy_playtype;
@property (nonatomic, strong)NSString *b_time;
@property (nonatomic, strong)NSString *images_url;
@property (nonatomic, strong)NSString *expert_id;
@end
