//
//  LTCurHeaderView.m
//  Lottery
//
//  Created by quentin on 16/5/17.
//  Copyright © 2016年 Quentin. All rights reserved.
//

#import "LTCurHeaderView.h"



@interface LTCurHeaderView ()

{
    UILabel  *_issueLabel;
    UILabel  *_timeLabel;
}

@end

@implementation LTCurHeaderView

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
    
    //issue
    _issueLabel = [[UILabel alloc] init];
    _issueLabel.textColor = [UIColor grayColor];
    _issueLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_issueLabel];
    
    //time
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = UIColorFromRGB(0xff8080);
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_timeLabel];
}
- (void)setTitle:(NSString *)title message:(NSString *)message{
    _title = title;
    _message = message;
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_title.length > 0) {
        _issueLabel.text = _title;
        
    }
    if (_message.length > 0) {
        _timeLabel.text = _message;
    }

    
    [_issueLabel sizeToFit];
    [_timeLabel sizeToFit];
    
    CGFloat x = 0, y = 0;
    
    //issue
    x = 15;
    y = 5;
    _issueLabel.frame = CGRectMake(x, y, CGRectGetWidth(_issueLabel.frame), CGRectGetHeight(_issueLabel.frame));
    
    //end time
    y = CGRectGetHeight(self.frame) - CGRectGetHeight(_timeLabel.frame) - 5;
    _timeLabel.frame = CGRectMake(x, y, CGRectGetWidth(_timeLabel.frame), CGRectGetHeight(_timeLabel.frame));
}

+ (CGFloat)height
{
    return 50;
}

@end
