//
//  LNUserInfoModel.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface user_data : JSONModel
@property (nonatomic, strong) NSString *c_time;
@property (nonatomic, strong) NSString *images_url;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *phone_number;
@property (nonatomic, strong) NSString *weixin_id;

@end
@interface LNUserInfoModel : JSONModel<NSCoding>
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) user_data *user_data;
@property (nonatomic, strong) NSString *user_gold;
@property (nonatomic, strong) NSString *login_type;
+ (void)saveUserInfo:(NSString *)pUid userInfo:(LNUserInfoModel *)model;
+(LNUserInfoModel *)getUserInfo:(NSString *)pUid;
@end
