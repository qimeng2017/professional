//
//  RankListCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/1/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "RankListCell.h"

@interface RankListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageview;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLable;
@property (weak, nonatomic) IBOutlet UILabel *testLable;

@end
@implementation RankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setRankListModel:(RankListModel *)rankListModel{
    [_avaterImageview sd_setImageWithURL:[NSURL URLWithString:rankListModel.images_url] placeholderImage:[UIImage imageNamed:@"Icon-Small"] options:SDWebImageProgressiveDownload];
    _nickNameLable.text = rankListModel.nickname;
    _testLable.text = [NSString stringWithFormat:@"(%@)",rankListModel.fore_data];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
