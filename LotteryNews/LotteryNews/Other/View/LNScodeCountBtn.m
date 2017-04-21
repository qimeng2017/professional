//
//  LNScodeCountBtn.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/23.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "LNScodeCountBtn.h"
#import "UIImage+ResizeImg.h"
@interface LNScodeCountBtn ()
{
    NSInteger _countdown;
    NSTimer * _countdownTimer;
}
@end
@implementation LNScodeCountBtn
@synthesize normalStateImageName = _normalStateImageName;
@synthesize highlightedStateImageName;
@synthesize selectedStateImageName;
@synthesize normalStateBgImageName;
@synthesize highlightedStateBgImageName;
@synthesize selectedStateBgImageName;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self sharedInit];
    }
    return self;
}
- (id)initWithCoder: (NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (id)sharedInit {
    
    [self pretreat];
    return self;
}
- (void)pretreat {
    self.countdownBeginNumber = 60;
    self.normalStateBgImageName = @"userinfo_relationship_button_background";
    self.highlightedStateBgImageName = @"userinfo_relationship_button_background";
    self.selectedStateBgImageName = @"userinfo_relationship_button_highlighted";
    self.normalStateImageName = @"timerBtn_imageView_normal";
    self.highlightedStateImageName = @"timerBtn_imageView_highlighted";
    self.selectedStateImageName = @"timerBtn_imageView_selected";
}
//- (void)setupBackgroundNotification {
//    //页面将要进入前台，开启定时器
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(distantPastTimer)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
//    
//    //页面消失，进入后台不显示该页面，关闭定时器
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(distantFutureTimer)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
//}
- (void)drawRect:(CGRect)rect
{
    _countdown = self.countdownBeginNumber - 1;
    [self setupSendSNSCodeButton];
}

- (void)setupSendSNSCodeButton {
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    //    self.layer.cornerRadius = 3.0;
    
    //    [self setBackgroundImage:[UIImage resizedImage:self.normalStateBgImageName] forState:UIControlStateNormal];
    //    [self setBackgroundImage:[UIImage resizedImage:self.highlightedStateBgImageName] forState:UIControlStateNormal];
    //    [self setBackgroundImage:[UIImage resizedImage:self.selectedStateBgImageName] forState:UIControlStateHighlighted];
    //    [self setImage:[UIImage imageWithName:self.normalStateImageName] forState:UIControlStateNormal];
    //    [self setImage:[UIImage imageWithName:self.highlightedStateImageName] forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13*kScreenWidthP];
    
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1*kScreenWidthP;
    self.layer.borderColor = RGBA(61, 192, 239, 1).CGColor;
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setTitleColor:RGBA(61, 192, 239, 1) forState:UIControlStateNormal];
    [self setTitleColor:RGBA(61, 192, 239, 1) forState:UIControlStateHighlighted];
    [self addTarget:self action:@selector(receiveCode) forControlEvents:UIControlEventTouchUpInside];
     
}

-(void)receiveCode{
    //    [self getCode];
    if ([self.delegate respondsToSelector:@selector(scodeCountBtnClicked)]) {
        [self.delegate scodeCountBtnClicked];
    }
    
}

- (void)initWithCountdownBeginNumber  {
    self.userInteractionEnabled = NO;
    [self setTitle:[NSString stringWithFormat:@"还剩%ld秒",self.countdownBeginNumber - 1] forState:UIControlStateNormal];
    //    [self setImage:[UIImage imageWithName:self.selectedStateImageName] forState:UIControlStateNormal];
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(closeGetVerifyButtonUser) userInfo:nil repeats:YES];
    
}

-(void)closeGetVerifyButtonUser
{
    //    [self setImage:[UIImage imageWithName:self.selectedStateImageName] forState:UIControlStateNormal];
    _countdown = _countdown-1;
    self.userInteractionEnabled = NO;
    [self setTitle:[NSString stringWithFormat:@"还剩%ld秒",(long)_countdown] forState:UIControlStateNormal];
    if(_countdown == 0){
//        [self setImage:[UIImage imageWithName:self.normalStateImageName] forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        [self setTitle:@"重新获取" forState:UIControlStateNormal];
        _countdown = self.countdownBeginNumber - 1;
        //注意此处不是暂停计时器,而是彻底注销,使_countdownTimer.valid == NO;
        
        [_countdownTimer invalidate];
    }
    
}


//开启定时器
-(void)distantPastTimer
{
        if([_countdownTimer isValid]&&(_countdown >0))
        //开启定时器
        [_countdownTimer setFireDate:[NSDate distantPast]];
}

//暂停定时器
-(void)distantFutureTimer
{
        if([_countdownTimer isValid]&&(_countdown >0))
        //暂停定时器
        [_countdownTimer setFireDate:[NSDate distantFuture]];
}
//关闭定时器
- (void)closeTimer{
    if ([_countdownTimer isValid]&&(_countdown >0)) {
        [_countdownTimer invalidate];
        self.userInteractionEnabled = YES;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:Nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:Nil];
//}


@end
