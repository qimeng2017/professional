//
//  SendNetworkTool.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/3/7.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "SendNetworkTool.h"

@interface SendNetworkTool ()
{
    dispatch_semaphore_t semaphore;
}
@end
@implementation SendNetworkTool
+ (SendNetworkTool *)SharedManager
{
    static SendNetworkTool *shareManger = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManger = [[self alloc] init];
    });
    
    return shareManger;
    
}
-(void)Get:(NSString *)url success:(HttpDownLoadSuccess)success failure:(HttpDownLoadFailure)failure
{
    semaphore = dispatch_semaphore_create(0); //创建信号量
    NSString *encodeUrl ;
    encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodeUrl]];
    
    
    //NSURLSession 请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            failure(error);
        }else{
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            success(result);
        }
        dispatch_semaphore_signal(semaphore);   //发送信号  +1
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
    
}
-(void)Post:(NSString *)url parameters:(NSDictionary *)param success:(HttpDownLoadSuccess)success failure:(HttpDownLoadFailure)failure
{
    semaphore = dispatch_semaphore_create(0); //创建信号量
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 15;
    request.HTTPMethod = @"POST";
    
    NSString *str = [self getParamStringByDictionary:param];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    
    //NSURLSession 请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            failure(error);
        }else{
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            success(result);
        }
        dispatch_semaphore_signal(semaphore);   //发送信号  +1
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
    
}

-(NSString*)getParamStringByDictionary:(NSDictionary*)dic
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithCapacity:0];
    
    for (id key in dic) {
        NSString *string = [NSString stringWithFormat:@"%@=%@&",key,[dic objectForKey:key]];
        [mutableString appendString:string];
    }
    
    [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length-1, 1)];
    return mutableString;
}

@end
