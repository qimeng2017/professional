//
//  TriolionCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/1/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "TriolionCell.h"

@interface TriolionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *IntroductionLable;
@property (weak, nonatomic) IBOutlet UIImageView *triolionImageView;

@end
@implementation TriolionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setTriolionModel:(TriolionModel *)triolionModel{
    _titleLable.text = triolionModel.title;
    _timeLable.text = triolionModel.datetime;
    _IntroductionLable.text = triolionModel.introduction;
    _triolionImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_triolionImageView setClipsToBounds:YES];
    [_triolionImageView sd_setImageWithURL:[NSURL URLWithString:triolionModel.imgurl] placeholderImage:nil options:SDWebImageRefreshCached];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
