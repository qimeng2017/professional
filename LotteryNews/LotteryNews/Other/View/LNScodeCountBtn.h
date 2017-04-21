//
//  LNScodeCountBtn.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/23.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LNScodeCountBtnDelegate <NSObject>

@optional
- (void)scodeCountBtnClicked;

@end
@interface LNScodeCountBtn : UIButton
@property (nonatomic, assign) NSInteger countdownBeginNumber;
@property (nonatomic, weak) id<LNScodeCountBtnDelegate> delegate;

@property (nonatomic, copy) NSString *normalStateImageName;
@property (nonatomic, copy) NSString *highlightedStateImageName;
@property (nonatomic, copy) NSString *selectedStateImageName;
@property (nonatomic, copy) NSString *normalStateBgImageName;
@property (nonatomic, copy) NSString *highlightedStateBgImageName;
@property (nonatomic, copy) NSString *selectedStateBgImageName;

- (void)initWithCountdownBeginNumber;
/**
开启定时器
 */
-(void)distantPastTimer;
/**
 暂停定时器
 */
-(void)distantFutureTimer;
/**
 关闭定时器
 */
- (void)closeTimer;
@end
