//
//  PPMDataModel.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface CurrentDataModel : JSONModel
@property (nonatomic, copy) NSString *expert_id;
@property (nonatomic, copy) NSString *fore_data;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *yc_content;
@property (nonatomic, copy) NSString *yc_status;
@property (nonatomic, copy) NSString *play_type;
@property (nonatomic, copy) NSString *cost_gold;
@property (nonatomic, copy) NSString *cost_message;
@property (nonatomic, assign) BOOL isLook;
@property (nonatomic, copy) NSString *is_buy;
@end
@interface PPMDataModel : JSONModel
@property (nonatomic, copy) NSString *images_url;
@property (nonatomic, copy) NSString *expert_id;
@property (nonatomic, copy) NSString *fore_data;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *yc_content;
@property (nonatomic, copy) NSString *yc_status;
@property (nonatomic, copy) NSString *play_type;
@property (nonatomic, copy) NSString *cost_gold;
@property (nonatomic, copy) NSString *cost_message;
@property (nonatomic, copy) NSString *buy_message;
@property (nonatomic, assign) BOOL isLook;
@property (nonatomic, copy) NSString *is_buy;
@property (nonatomic, copy) NSString *is_playtype_blue;
@property (nonatomic, copy)NSString *caipiaoid;
@property (nonatomic, copy)NSString *caipiao_name;
@property (nonatomic, copy)NSString *play_type_name;
@property (nonatomic, copy)NSString *playtype;
@end
