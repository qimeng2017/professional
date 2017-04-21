//
//  RankListModel.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/1/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RankListModel : JSONModel
@property (nonatomic, strong)NSString *expert_id;
@property (nonatomic, strong)NSString *fore_data;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *images_url;
@end
