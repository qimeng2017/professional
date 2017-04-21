//
//  HistoryModel.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/27.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HistoryModel : JSONModel
@property (nonatomic, copy)NSString   *caipiaoid;
@property (nonatomic, copy)NSString   *caipiao_name;

@property (nonatomic, copy)NSString   *playtype;
@property (nonatomic, copy)NSString   *blueball;
@property (nonatomic, copy)NSString   *number;
@property (nonatomic, copy)NSString   *yc_status;
@property (nonatomic, strong)NSString *yc_content;
@property (nonatomic, copy)NSString   *issueno;
@property (nonatomic, copy)NSString   *play_type_name;
@property (nonatomic, strong)NSString *is_playtype_blue;
@property (nonatomic,assign) BOOL     isBuy;
@property (nonatomic, copy) NSString  *cost_gold;
@property (nonatomic, copy) NSString  *message;
@property (nonatomic, copy) NSString  *is_buy;

@end
