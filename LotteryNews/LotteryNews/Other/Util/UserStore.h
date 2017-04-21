//
//  UserStore.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/23.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LottoryCategoryModel.h"
#import "LottoryPlaytypemodel.h"

typedef void(^sucessCompleteBlock)(NSURLSessionDataTask *task, id responseObject);

typedef void(^failureCompleteBlock)(NSURLSessionDataTask *task, NSError * error);

@interface UserStore : NSObject
+ (UserStore *)sharedInstance;
//用户登录
- (void)loginUser:(NSDictionary *)loginUserInfo login_type:(NSString *)login_type sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;

-(void)getAccess_token:(NSString *)code sucess:(void(^)( NSDictionary *dict))block;
//获取验证码
- (void)getScode:(NSString *)phone_number sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;

- (void)getCategoriesAndPlayTypeDefult;
//彩种分类接口
- (void)getCategories:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
//获取彩票玩法接口
- (void)requestPlayType:(LottoryCategoryModel *)model sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
//获取彩票数据
- (void)request:(NSString *)caipiaoid play_type:(LottoryPlaytypemodel *)play_type jisu_api_id:(NSString *)jisu_api_id isNewData:(BOOL)newData sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
//获取用户信息
- (void)requestGetUserInfoWithUserId:(NSString *)userId sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
//我的购买
- (void)getBuyRecord:(NSString *)userId sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
//充值记录
- (void)getRechargeRecord:(NSString *)userId sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
//获取专家信息接口
- (void)getHomePage:(NSString *)expert_id sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
//获取专家历史预测数据
- (void)getexpertData:(NSString *)expert_id categoryModel:(LottoryCategoryModel *)categoryModel playModel:(LottoryPlaytypemodel *)playModel sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
// 购买预测内容接口
- (void)buyExpertData:(NSString *)expert_id userId:(NSString *)userId info:(NSMutableDictionary *)infoDict sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
//内购接口更改状态
- (void)checkReviewTheStatus;

//做任务送金币 =1好评任务，2签到任务
- (void)gold_manage:(NSString *)userid task_type:(NSString *)task_type sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;

//广告弹窗
- (void)ios_ad_manage:(NSString *)userid sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;



#pragma mark - 内购
- (void)appleOrdeTotal_fee:(NSString *)total_fee out_trade_no:(NSString *)out_trade_no recharge_gold:(NSString *)recharge_gold sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
//绑定手机号 或 微信
- (void)account_bind:(NSDictionary *)weiInfo weixinid:(NSString *)weixin phone:(NSString *)phone sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;

//资讯页面接口
- (void)newsCategory:(NSString *)category page:(NSInteger)page sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;

//排行榜页面
- (void)expert_rank:(NSDictionary *)dict sucess:(sucessCompleteBlock)sucessBlock failure:(failureCompleteBlock)failureBlock;
@end
