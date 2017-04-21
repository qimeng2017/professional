//
//  LNUserInfoModel.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "LNUserInfoModel.h"
#import "HRPathManager.h"

@implementation user_data

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end
@implementation LNUserInfoModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
+ (NSString *)getCachePathOfUser:(NSString *)pUid{
    NSString *docPath = [HRPathManager  documentPathWithSubDirectoryName:@"userInfo"];
    NSString *fileName = [NSString stringWithFormat:@"userInfo1_%@.db", pUid];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    return filePath;
}
+ (void)saveUserInfo:(NSString *)pUid userInfo:(LNUserInfoModel *)model{
    NSString *cachePath = [LNUserInfoModel getCachePathOfUser:pUid];
    if (self) {
        [NSKeyedArchiver archiveRootObject:model toFile:cachePath];
    }
}
+(LNUserInfoModel *)getUserInfo:(NSString *)pUid{
  NSString *cachePath = [LNUserInfoModel getCachePathOfUser:pUid];
  LNUserInfoModel *aUser = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    return aUser;
}
@end
