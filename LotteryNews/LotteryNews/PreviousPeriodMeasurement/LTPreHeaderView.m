//
//  LTPreHeaderView.m
//  Lottery
//
//  Created by quentin on 16/5/16.
//  Copyright © 2016年 Quentin. All rights reserved.
//

#import "LTPreHeaderView.h"
#import "NSString+Util.h"

@interface LTPreHeaderView ()

{
    UILabel  *_lotteryDateLabel;//期数
    UIButton *_playDesButton;
    UIView   *_ballBgView;    
}
@end

@implementation LTPreHeaderView
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    self.backgroundColor = [UIColor whiteColor];
    
    //date
    _lotteryDateLabel = [[UILabel alloc] init];
    _lotteryDateLabel.textColor = [UIColor grayColor];
    _lotteryDateLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_lotteryDateLabel];
    
    //play
    UIImage *image = [UIImage imageNamed:@"ball__square"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    
    _playDesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playDesButton setBackgroundImage:image forState:UIControlStateNormal];
    [_playDesButton setTitle:@"玩法说明" forState:UIControlStateNormal];
    _playDesButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    _playDesButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_playDesButton addTarget:self action:@selector(onPlayDesClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playDesButton];
    
    //ball
    UIImage *ballImage = [UIImage imageNamed:@"ball_red"];
    
    _ballBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), ballImage.size.height)];
    [self addSubview:_ballBgView];

}

- (void)customBall
{
    for (UIView *view in _ballBgView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat x = 0;
    
 

    NSArray *nums = [_number componentsSeparatedByString:@","];
    
    for (NSInteger index = 0; index < [nums count]; index ++) {
        
        UIButton *ballBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ballBtn setBackgroundImage:[UIImage imageNamed:@"ball_red"] forState:UIControlStateNormal];
        ballBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [ballBtn setTitle:[nums objectAtIndex:index] forState:UIControlStateNormal];
        [ballBtn sizeToFit];
        ballBtn.frame = CGRectMake(x, 0, CGRectGetWidth(ballBtn.frame), CGRectGetHeight(ballBtn.frame));
        
        x += CGRectGetWidth(ballBtn.frame) + 2;
        
        [_ballBgView addSubview:ballBtn];
        
    }
    
    if (_blueball.length > 0) {
        nums = [_blueball componentsSeparatedByString:@","];
        
        for (NSInteger index = 0; index < [nums count]; index ++) {
            
            UIButton *ballBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [ballBtn setBackgroundImage:[UIImage imageNamed:@"ball_blue"] forState:UIControlStateNormal];
            ballBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [ballBtn setTitle:[nums objectAtIndex:index] forState:UIControlStateNormal];
            [ballBtn sizeToFit];
            ballBtn.frame = CGRectMake(x, 0, CGRectGetWidth(ballBtn.frame), CGRectGetHeight(ballBtn.frame));
            
            x += CGRectGetWidth(ballBtn.frame) + 2;
            
            [_ballBgView addSubview:ballBtn];
            
        }
    }

}


- (void)setNumber:(NSString *)number blueball:(NSString *)blueball open_issueno:(NSString *)open_issueno{
    [self setNeedsLayout];
    _number = number;
    _blueball = blueball;
    _open_issueno = open_issueno;
    [self customBall];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_open_issueno.length > 0) {
        _lotteryDateLabel.text = [NSString stringWithFormat:@"开奖号码 %@期", _open_issueno];
    }
    
    [_lotteryDateLabel sizeToFit];
    [_playDesButton sizeToFit];
    [_ballBgView sizeToFit];
    
    CGFloat x = 0, y = 0;
    
    //date
    x = 15;
    y = 5;
    _lotteryDateLabel.frame = CGRectMake(x, y, CGRectGetWidth(_lotteryDateLabel.frame), CGRectGetHeight(_lotteryDateLabel.frame));
    
    //ball
    y = CGRectGetHeight(self.frame) - CGRectGetHeight(_ballBgView.frame) - 5;
    _ballBgView.frame = CGRectMake(x, y, CGRectGetWidth(self.frame), CGRectGetHeight(_ballBgView.frame));
    
    //play
    x = CGRectGetWidth(self.frame) - CGRectGetWidth(_playDesButton.frame) - 15 - 10;
    y = (CGRectGetHeight(self.frame) - CGRectGetHeight(_playDesButton.frame)) / 2;
    _playDesButton.frame = CGRectMake(x, y, CGRectGetWidth(_playDesButton.frame) + 10, CGRectGetHeight(_playDesButton.frame));
}

+ (CGFloat)height
{
    return 60;
}

#pragma mark - on click

- (void)onPlayDesClick:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(LTPreHeaderView:onPlayDesClick:)]) {
        [delegate LTPreHeaderView:self onPlayDesClick:sender];
    }
}

@end
