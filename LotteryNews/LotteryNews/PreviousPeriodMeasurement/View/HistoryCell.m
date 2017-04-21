//
//  HistoryCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/27.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HistoryCell.h"
#import "NSString+Extension.h"
#import "LNLottoryConfig.h"
@interface HistoryCell ()
{
    UILabel *_predictPeriodsLable;//预测期数
    UILabel *_playNameLabel;//玩法
    UILabel *_predictionLable;//预测号
    UIButton *_statusButton;
    UIView  *_centerView;
    UILabel *_lotteryNumberLabel;//开奖号吗
    UIView  *_ballBgView;
    UILabel *_messageLable;
    
}
@end
@implementation HistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customInit];
    }
    return self;
}
- (void)customInit{
    
    _predictPeriodsLable = [[UILabel alloc] init];
    _predictPeriodsLable.textColor = UIColorFromRGB(0x008800);
    _predictPeriodsLable.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_predictPeriodsLable];
    
    _playNameLabel = [[UILabel alloc] init];
    _playNameLabel.textColor = UIColorFromRGB(0xff8080);
    _playNameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_playNameLabel];
    
    _predictionLable = [[UILabel alloc] init];
    _predictionLable.textColor = UIColorFromRGB(0xff8080);
    _predictionLable.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_predictionLable];
    _messageLable = [[UILabel alloc] init];
    _messageLable.textColor = UIColorFromRGB(0xff8080);
    _messageLable.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_messageLable];
   
    
    
    UIImage *image = [UIImage imageNamed:@"ball__square"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_statusButton setBackgroundImage:image forState:UIControlStateNormal];
    [_statusButton setTitle:LSTR(@"查看") forState:UIControlStateNormal];
    _statusButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);

    [_statusButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // _statusButton.backgroundColor = UIColorFromRGB(0xff8080);
    [self.contentView addSubview:_statusButton];
    
    //ball
    UIImage *ballImage = [UIImage imageNamed:@"ball_red"];
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.frame), ballImage.size.height)];
    [self addSubview:_centerView];

    _ballBgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.frame), ballImage.size.height)];
    [self addSubview:_ballBgView];

}

- (void)setHistoryModel:(HistoryModel *)historyModel{
    [self setNeedsLayout];
    _historyModel = historyModel;
    _content = historyModel.yc_content;
    _blueball = historyModel.blueball;
    _number = historyModel.number;
 
    
    
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_historyModel.message) {
        _messageLable.hidden = NO;
        _messageLable.text = _historyModel.message;
        _ballBgView.hidden = YES;
        _statusButton.hidden = NO;
        if ([_historyModel.is_buy isEqualToString:@"1"]) {
           [_statusButton setBackgroundImage:[UIImage imageNamed:@"ball__square_green"] forState:UIControlStateNormal];
            [_statusButton setTitle:@"已购" forState:UIControlStateNormal];
//            _statusButton.layer.borderColor = [UIColor redColor].CGColor;
//            _statusButton.layer.borderWidth = 0.5;
//            _statusButton.backgroundColor = RGBA(255, 232, 232, 1);
            _messageLable.hidden = YES;
            _centerView.hidden = NO;
            _statusButton.userInteractionEnabled = NO;
            
        }else{
            [_statusButton setBackgroundImage:[UIImage imageNamed:@"ball__square"] forState:UIControlStateNormal];
            [_statusButton setTitle:@"查看" forState:UIControlStateNormal];
            _messageLable.hidden = NO;
            _centerView.hidden = YES;
            _statusButton.userInteractionEnabled =  YES;

        }
    }else{
        _centerView.hidden = NO;
        _ballBgView.hidden = NO;
        _statusButton.hidden = YES;
        _messageLable.hidden = YES;
    }
    
    _predictPeriodsLable.text = [NSString stringWithFormat:@"%@预测",_historyModel.issueno];
    _playNameLabel.text = _historyModel.yc_status;
   
    
    [_predictPeriodsLable sizeToFit];
    [_playNameLabel sizeToFit];
     [_predictionLable sizeToFit];
     [_statusButton sizeToFit];
    [_messageLable sizeToFit];
  
    CGFloat x = 0, y = 0;
    x = 15;
    y = 5;
    _predictPeriodsLable.frame = CGRectMake(x, y, CGRectGetWidth(_predictPeriodsLable.frame), CGRectGetHeight(_predictPeriodsLable.frame));
    _playNameLabel.frame = CGRectMake(CGRectGetMaxX(_predictPeriodsLable.frame)+5, y, CGRectGetWidth(_playNameLabel.frame), CGRectGetHeight(_playNameLabel.frame));
    
    _statusButton.frame = CGRectMake(kScreenWidth - CGRectGetWidth(_statusButton.frame)-x-20, CGRectGetMaxY(_predictPeriodsLable.frame)+y, CGRectGetWidth(_statusButton.frame)+20, CGRectGetHeight(_statusButton.frame));
    CGFloat messageW  = 0;
    if (CGRectGetMaxX(_messageLable.frame) >= (CGRectGetMinX(_statusButton.frame)+20)) {
        messageW = kScreenWidth - x - (CGRectGetMinX(_statusButton.frame)+30);
    }else{
        messageW = CGRectGetWidth(_messageLable.frame);
    }
    _messageLable.frame = CGRectMake(x, CGRectGetMaxY(_predictPeriodsLable.frame)+10, messageW, CGRectGetHeight(_messageLable.frame));
    [self createContent];
    [self customBall];
}
- (void)createContent{
    for (UIView *view in _centerView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat x = 15;
    CGFloat y = CGRectGetMaxY(_predictPeriodsLable.frame)+5;
    if (_content.length > 0) {
        NSArray *nums = [_content componentsSeparatedByString:@","];
        
        for (NSInteger index = 0; index < [nums count]; index ++) {
            
            UIButton *ballBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if ([_historyModel.is_playtype_blue isEqualToString:@"1"]) {
                 [ballBtn setBackgroundImage:[UIImage imageNamed:@"ball_blue"] forState:UIControlStateNormal];
            }else{
               [ballBtn setBackgroundImage:[UIImage imageNamed:@"ball_red"] forState:UIControlStateNormal];
            }
           
            ballBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [ballBtn setTitle:[nums objectAtIndex:index] forState:UIControlStateNormal];
            [ballBtn sizeToFit];
            ballBtn.frame = CGRectMake(x, 0, CGRectGetWidth(ballBtn.frame), CGRectGetHeight(ballBtn.frame));
            
            x += CGRectGetWidth(ballBtn.frame) + 2;
            
            [_centerView addSubview:ballBtn];
            
        }
    }
    _centerView.frame = CGRectMake(15, y, kScreenWidth, CGRectGetHeight(_centerView.frame));
 
}
- (void)customBall
{
    for (UIView *view in _ballBgView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    UILabel *lable = [[UILabel alloc]init];
    lable.textColor = [UIColor grayColor];
    lable.font = [UIFont systemFontOfSize:14];
    [_ballBgView addSubview:lable];
    lable.text = @"开奖号码:";
    [lable sizeToFit];
    lable.frame = CGRectMake(x,(CGRectGetHeight(_ballBgView.frame)- CGRectGetHeight(lable.frame))/2, CGRectGetWidth(lable.frame), CGRectGetHeight(lable.frame));
    
    x= CGRectGetWidth(lable.frame) + 5;
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
    y  = CGRectGetMaxY(_predictPeriodsLable.frame)+15+CGRectGetHeight(_ballBgView.frame);
    _ballBgView.frame = CGRectMake(15, y, kScreenWidth, CGRectGetHeight(_ballBgView.frame));
}

- (void)buyAction:(UIButton *)sender{
    if (_delegate &&[_delegate respondsToSelector:@selector(HistoryTableViewCell:buyModel:indexPath:)]) {
        [_delegate HistoryTableViewCell:self buyModel:_historyModel indexPath:_indexPath];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
