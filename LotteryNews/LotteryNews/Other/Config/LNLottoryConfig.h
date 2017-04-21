//
//  LNLottoryConfig.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//通知
extern NSString * const kLotteryDateSuccessedNotification;
extern NSString * const kLotteryDateSuccessedFristNotification;

extern NSString * const kLotteryDataCategoryNotification;

extern NSString * const LOTTORY_AUTHORIZATION_UID;//用户 id
extern NSString * const LOTTORY_REVIEW_STATUS;//状态
extern NSString * const LOTTORY_USER_INFO; //用户信息
extern NSString * const appid;
extern NSString * const app_type;//版本号
extern NSString * const appname;
extern NSString * const templateReviewURL;
extern NSString * const templateReviewURLiOS7;
extern NSString * const templateReviewURLiOS8;


extern NSString * LOTTERY_HOST_NAME_SEVER;
extern NSString * LOTTERY_HOST_NAME_RELEASE;
typedef NS_ENUM(NSInteger,LN_loginType) {
  LN_loginType_phone,
  LN_loginType_weixin
};
