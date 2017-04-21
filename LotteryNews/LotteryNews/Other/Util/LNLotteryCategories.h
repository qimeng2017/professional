//
//  LNLotteryCategories.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LottoryCategoryModel.h"
#import "LottoryPlaytypemodel.h"
@interface LNLotteryCategories : NSObject
+(LNLotteryCategories *)sharedInstance;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSArray *categoryPlayArray;
@property (nonatomic, assign) NSInteger categorySelectedIndex;/**<当前类型索引*/
@property (nonatomic, assign) NSInteger playTypeSelectedIndex;/**<当前类型索引*/
@property (nonatomic, strong) LottoryCategoryModel *currentLottoryModel;
@property (nonatomic, strong) LottoryPlaytypemodel *currentPlaytypeModel;
@end
