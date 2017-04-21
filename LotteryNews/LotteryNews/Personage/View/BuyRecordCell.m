//
//  BuyRecordCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "BuyRecordCell.h"

@interface BuyRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *playType;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end
@implementation BuyRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setBuyModel:(BuyRecordModel *)buyModel{
    
    _buyModel = buyModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:buyModel.images_url] placeholderImage:[UIImage imageNamed:@"Icon-Small"] options:SDWebImageProgressiveDownload];
    self.nickName.text = buyModel.expert_name;
    self.content.text = buyModel.yc_content;
    self.playType.text = buyModel.buy_playtype;
    self.time.text = buyModel.b_time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
