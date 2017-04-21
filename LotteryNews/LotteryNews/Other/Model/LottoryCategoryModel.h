//
//  LottoryCategoryModel.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LottoryCategoryModel : JSONModel
@property (nonatomic, strong) NSString *caipiao_name;
@property (nonatomic, strong) NSString *caipiaoid;
@property (nonatomic, strong) NSString *jisu_api_id;
@end
