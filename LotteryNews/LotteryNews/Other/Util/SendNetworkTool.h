//
//  SendNetworkTool.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/3/7.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^HttpDownLoadSuccess)(NSDictionary *res);
typedef void (^HttpDownLoadFailure)(NSError *error);
@interface SendNetworkTool : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

+ (SendNetworkTool *)SharedManager;
-(void)Get:(NSString*)url success:(HttpDownLoadSuccess)success failure:(HttpDownLoadFailure)failure;

-(void)Post:(NSString*)url parameters:(NSDictionary*)param success:(HttpDownLoadSuccess)success failure:(HttpDownLoadFailure)failure;
@end
