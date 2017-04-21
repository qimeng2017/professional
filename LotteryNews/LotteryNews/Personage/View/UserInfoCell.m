//
//  UserInfoCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "UserInfoCell.h"
#import "KBRoundedButton.h"
#import "LNLottoryConfig.h"
@interface UserInfoCell()
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@end
@implementation UserInfoCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat avatarHeight = 80;
       
        CGFloat margin = 10;
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        
        avatarImageView.frame =CGRectMake(margin, margin, avatarHeight , avatarHeight);
        avatarImageView.backgroundColor = [UIColor redColor];
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width * 0.5;
        avatarImageView.layer.masksToBounds = YES;
        [self addSubview:avatarImageView];
        self.avatarImageView = avatarImageView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        self.nameLabel = nameLabel;
        CGFloat nameLabelHeight = 21.5;
        nameLabel.font = [UIFont systemFontOfSize:18];
        
        nameLabel.frame = CGRectMake(CGRectGetMaxX(avatarImageView.frame) + margin, avatarImageView.frame.origin.y +avatarImageView.frame.size.height*0.5 - nameLabelHeight-0.5*margin, kScreenWidth - 3*margin -avatarImageView.frame.size.width, nameLabelHeight);
       
        [self addSubview:nameLabel];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        self.contentLabel = contentLabel;
        CGFloat contentLabelHeight = 17.5;
        
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.frame = CGRectMake(CGRectGetMaxX(avatarImageView.frame) + margin, avatarImageView.frame.origin.y +avatarImageView.frame.size.height*0.5+0.5*margin, kScreenWidth - 3*margin -avatarImageView.frame.size.width, contentLabelHeight);
        contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self addSubview:contentLabel];
        
        CGFloat spaceW = 30;
        CGFloat btnW = (kScreenWidth - 2*margin -spaceW)/2;
        CGFloat btnH = 40;
        
        
        KBRoundedButton *rechargeBtn = [[KBRoundedButton alloc]init];
        [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        rechargeBtn.frame = CGRectMake(margin, CGRectGetMaxY(avatarImageView.frame)+margin*2, btnW, btnH);
        rechargeBtn.backgroundColor = [UIColor colorWithHexString:@"#22ac38"];
        [rechargeBtn addTarget:self action:@selector(rechargeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rechargeBtn];
        
        KBRoundedButton *reloadDataBtn = [[KBRoundedButton alloc]init];
        reloadDataBtn.frame = CGRectMake(CGRectGetMaxX(rechargeBtn.frame) + spaceW, CGRectGetMaxY(avatarImageView.frame)+margin*2, btnW, btnH);
         [reloadDataBtn setTitle:@"刷新" forState:UIControlStateNormal];
        reloadDataBtn.backgroundColor = [UIColor colorWithHexString:@"#22ac38"];
        [self addSubview:reloadDataBtn];
        [reloadDataBtn addTarget:self action:@selector(reloadDataAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(avatarImageView.frame)+margin, kScreenWidth, 0.5)];
        line1.backgroundColor = [UIColor grayColor];
        [self addSubview:line1];
        //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

        
    }
    return self;
}
- (void)rechargeAction:(UIButton *)sender{
    if (_delegate&&[_delegate respondsToSelector:@selector(recharge)]) {
        [_delegate recharge];
    }
}
- (void)reloadDataAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(reloadData)]) {
        [_delegate reloadData];
    }
}
- (void)setAvatarImage:(NSString *)image Name:(NSString *)name Signature:(NSString *)content {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"Icon-Small"] options:SDWebImageProgressiveDownload];
    self.nameLabel.text = name;
    self.contentLabel.text = [NSString stringWithFormat:@"金币:%@",content];
    
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
