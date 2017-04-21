//
//  TriolionModel.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/1/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TriolionModel : JSONModel
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *datetime;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *introduction;
@end
