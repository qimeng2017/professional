//
//  PPMTableViewCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "PPMTableViewCell.h"

@interface PPMTableViewCell ()
{
    UIImageView *_avatarImageView;//头像
    UILabel *_levelLabel;//等级
    UIButton *_userNameLabel;//名字
    UILabel *_hitNumLabel;
    
    UIView  *_bottomView;
    
    UILabel *_awardNameLabel;//名称
    
    UILabel *_playNameLabel;//玩法
    UILabel *_calLabel;//
    
    UIButton *_lookBtn;
    UILabel *_messageLable;
    UIView  *_ballBgView;
}
@end
@implementation PPMTableViewCell
@synthesize delegate;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapUserClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onUserClickCell:)];
        [self addGestureRecognizer:tapUserClick];
        
        [self customInit];
    }
    return self;
}
- (void)customInit
{
    CGFloat x = 0, y = 8,w = CGRectGetHeight(self.frame)-2*y;
    x = 15;
    
    _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, w)];
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = w/2;
    [self.contentView addSubview:_avatarImageView];
    //level
    _levelLabel = [[UILabel alloc] init];
    _levelLabel.textColor = UIColorFromRGB(0x008800);
    _levelLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_levelLabel];
    
    //user name
    _userNameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userNameLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _userNameLabel.titleLabel.font = [UIFont systemFontOfSize:14];
    [_userNameLabel addTarget:self action:@selector(onUserClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_userNameLabel];
    
    //hit num
    _hitNumLabel = [[UILabel alloc] init];
    _hitNumLabel.textColor = [UIColor redColor];
    _hitNumLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_hitNumLabel];
    
    //bottom view
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = UIColorFromRGB(0xfafafa);
    [self.contentView addSubview:_bottomView];
    
    //award name
    _awardNameLabel = [[UILabel alloc] init];
    _awardNameLabel.textColor = [UIColor redColor];
    _awardNameLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:_awardNameLabel];
    
    //play name
    _playNameLabel = [[UILabel alloc] init];
    _playNameLabel.textColor = [UIColor grayColor];
    _playNameLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:_playNameLabel];
    
    //cal
    _calLabel = [[UILabel alloc] init];
    _calLabel.textColor = UIColorFromRGB(0xff8080);
    _calLabel.numberOfLines = 0;
    _calLabel.font = [UIFont systemFontOfSize:13];
   // [_bottomView addSubview:_calLabel];
    _ballBgView = [[UIView alloc]init];
    [_bottomView addSubview:_ballBgView];
    //message
    _messageLable = [[UILabel alloc] init];
    _messageLable.textColor = UIColorFromRGB(0xff8080);
    _messageLable.numberOfLines = 0;
    _messageLable.font = [UIFont systemFontOfSize:13];
    [_bottomView addSubview:_messageLable];
    //look
    UIImage *image = [UIImage imageNamed:@"ball__square"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    
    _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_lookBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_lookBtn setTitle:LSTR(@"查看") forState:UIControlStateNormal];
    _lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _lookBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [_lookBtn addTarget:self action:@selector(onLookClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_lookBtn];
}

- (void)setItem:(PPMDataModel *)item{
    [self setNeedsLayout];
    _item = item;
    _number = _item.yc_content;
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_item.images_url] placeholderImage:[UIImage imageNamed:@"Icon-Small"] options:SDWebImageProgressiveDownload];
    _levelLabel.text = LSTR(@"(专家)");
    [_userNameLabel setTitle:_item.nickname forState:UIControlStateNormal];
    _hitNumLabel.text = _item.fore_data;
    _playNameLabel.text = _item.play_type;
    if (_item.cost_message) {
        _lookBtn.hidden = NO;
        if ([_item.is_buy isEqualToString:@"0"]) {
            _ballBgView.hidden = YES;
            _messageLable.hidden = NO;
            _messageLable.text = _item.cost_message;
            _lookBtn.userInteractionEnabled = YES;
           [_lookBtn setTitle:LSTR(@"查看") forState:UIControlStateNormal];
           [_lookBtn setBackgroundImage:[UIImage imageNamed:@"ball__square"] forState:UIControlStateNormal];
        }else if([_item.is_buy isEqualToString:@"1"]){
             _messageLable.hidden = YES;
            [_lookBtn setTitle:LSTR(@"已购") forState:UIControlStateNormal];
            [_lookBtn setBackgroundImage:[UIImage imageNamed:@"ball__square_green"] forState:UIControlStateNormal];
            
            _ballBgView.hidden = NO;
            _lookBtn.userInteractionEnabled = NO;
        }
    }else{
       
        _lookBtn.hidden = YES;
    }
    
    
    _awardNameLabel.text = _item.yc_status;
    [_levelLabel sizeToFit];
    [_userNameLabel sizeToFit];
    [_hitNumLabel sizeToFit];
    [_awardNameLabel sizeToFit];
    [_playNameLabel sizeToFit];
    //[_calLabel sizeToFit];
    [_lookBtn sizeToFit];
    [_messageLable sizeToFit];
    CGFloat x = 0, y = 0;
    
    //等级

    
    
    //用户名称
    x = CGRectGetMaxX(_avatarImageView.frame) + 5;
    y = (CGRectGetHeight(self.frame) / 2 - CGRectGetHeight(_userNameLabel.frame)) / 2;
    _userNameLabel.frame = CGRectMake(x, y, CGRectGetWidth(_userNameLabel.frame), CGRectGetHeight(_userNameLabel.frame));
    y = (CGRectGetHeight(self.frame) / 2 - CGRectGetHeight(_levelLabel.frame)) / 2;
    x = CGRectGetMaxX(_userNameLabel.frame) + 5;
    _levelLabel.frame = CGRectMake(x, y, CGRectGetWidth(_levelLabel.frame), CGRectGetHeight(_levelLabel.frame));
    //期数
    x = CGRectGetMaxX(_levelLabel.frame) + 15;
    y = (CGRectGetHeight(self.frame) / 2 - CGRectGetHeight(_hitNumLabel.frame)) / 2;
    _hitNumLabel.frame = CGRectMake(x, y, CGRectGetWidth(_hitNumLabel.frame), CGRectGetHeight(_hitNumLabel.frame));
    
    //bottom
    x = 0;
    y = CGRectGetHeight(self.frame) / 2;
    _bottomView.frame = CGRectMake(x, y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2);
    
    //玩法名称
    x = CGRectGetWidth(self.frame) - CGRectGetWidth(_awardNameLabel.frame) - 15;
    y = (CGRectGetHeight(_bottomView.frame) - CGRectGetHeight(_awardNameLabel.frame)) / 2;
    _awardNameLabel.frame = CGRectMake(x, y, CGRectGetWidth(_awardNameLabel.frame), CGRectGetHeight(_awardNameLabel.frame));
    
    //play name
    x = CGRectGetMinX(_levelLabel.frame);
    y = (CGRectGetHeight(_bottomView.frame) - CGRectGetHeight(_playNameLabel.frame)) / 2;
    _playNameLabel.frame = CGRectMake(x, y, CGRectGetWidth(_playNameLabel.frame), CGRectGetHeight(_playNameLabel.frame));
    
    //look
    x = CGRectGetWidth(self.frame) - CGRectGetWidth(_lookBtn.frame) - 15 - 10;
    y = (CGRectGetHeight(_bottomView.frame) - CGRectGetHeight(_lookBtn.frame) - 10) / 2;
    _lookBtn.frame = CGRectMake(x, y, CGRectGetWidth(_lookBtn.frame) + 10, CGRectGetHeight(_lookBtn.frame));
    _ballBgView.frame = CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame)-CGRectGetWidth(_lookBtn.frame) - 10, CGRectGetHeight(_bottomView.frame));
    //cal
    x = CGRectGetMaxX(_playNameLabel.frame) + 5;
    
    CGRect rect = [_calLabel.text boundingRectWithSize:CGSizeMake(CGRectGetMinX(_lookBtn.frame) - CGRectGetMaxX(_playNameLabel.frame) - 10, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _calLabel.font} context:NULL];
    y = (CGRectGetHeight(_bottomView.frame) - CGRectGetHeight(rect)) / 2;
    _calLabel.frame = CGRectMake(x, y, CGRectGetWidth(rect), CGRectGetHeight(rect));
    
    x = 15;
    CGRect rect1 = [_messageLable.text boundingRectWithSize:CGSizeMake(CGRectGetMinX(_lookBtn.frame) - CGRectGetMaxX(_playNameLabel.frame) - 10, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _calLabel.font} context:NULL];
    y = (CGRectGetHeight(_bottomView.frame) - CGRectGetHeight(rect1)) / 2;
    _messageLable.frame = CGRectMake(x, y, CGRectGetWidth(rect1), CGRectGetHeight(rect1));
    [self createContent];
}


- (void)createContent{
    for (UIView *view in _ballBgView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat x = 0;
    x= 15;
    NSArray *nums = [_number componentsSeparatedByString:@","];
    
    for (NSInteger index = 0; index < [nums count]; index ++) {
        
        UIButton *ballBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([_item.is_playtype_blue isEqualToString:@"1"]) {
            [ballBtn setBackgroundImage:[UIImage imageNamed:@"ball_blue"] forState:UIControlStateNormal];
        }else{
            [ballBtn setBackgroundImage:[UIImage imageNamed:@"ball_red"] forState:UIControlStateNormal];
        }

        ballBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [ballBtn setTitle:[nums objectAtIndex:index] forState:UIControlStateNormal];
        [ballBtn sizeToFit];
        ballBtn.frame = CGRectMake(x, (CGRectGetHeight(_bottomView.frame)- CGRectGetHeight(ballBtn.frame))/2, CGRectGetWidth(ballBtn.frame), CGRectGetHeight(ballBtn.frame));
        
        x += CGRectGetWidth(ballBtn.frame) + 2;
        
        [_ballBgView addSubview:ballBtn];
        
    }
    
}
- (void)onUserClickCell:(UITapGestureRecognizer *)tapGes{
    CGPoint point=[tapGes locationInView:self];
    if (point.x < self.frame.size.width*2/3) {
        if (delegate && [delegate respondsToSelector:@selector(PPMTableViewCell:onUserClick:)]) {
            [delegate PPMTableViewCell:self onUserClick:_item];
        }
    }
    
}
- (void)onUserClick:(UIButton *)sender{
    if (delegate && [delegate respondsToSelector:@selector(PPMTableViewCell:onUserClick:)]) {
        [delegate PPMTableViewCell:self onUserClick:_item];
    }
}
- (void)onLookClick:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(PPMTableViewCell:onLookClick: indexPath:)]) {
        [delegate PPMTableViewCell:self onLookClick:_item indexPath:_indexPath];
    }
}
#pragma mark - 高度，就这样写吧，简单

+ (CGFloat)height
{
    return 60;
}

+ (CGFloat)curHeight
{
    return 100;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
