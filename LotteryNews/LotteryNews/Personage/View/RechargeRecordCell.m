//
//  RechargeRecordCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "RechargeRecordCell.h"

@interface RechargeRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *EBAccountL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *rechargeNumberL;
@property (weak, nonatomic) IBOutlet UILabel *goldL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end
@implementation RechargeRecordCell
//- (id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(copyDealNumber)];
//        [self addGestureRecognizer:longGes];
//    }
//    return self;
//}
//- (id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(copyDealNumber)];
//        [self addGestureRecognizer:longGes];
//    }
//    return self;
//    
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(copyDealNumber)];
    [self addGestureRecognizer:longGes];
    // Initialization code
}
- (void)setRechargeModel:(RechargeRecordModel *)rechargeModel{
    _rechargeModel = rechargeModel;
    _EBAccountL.text = [NSString stringWithFormat:@"订单号:%@",rechargeModel.deal_number];
    _statusL.text = rechargeModel.recharge_status;
    _rechargeNumberL.text = [NSString stringWithFormat:@"充值金额:%@",rechargeModel.recharge_money];
    _goldL.text = [NSString stringWithFormat:@"兑换金币:%@",rechargeModel.recharge_gold];
    _timeL.text = [NSString stringWithFormat:@"充值时间:%@",rechargeModel.r_time];
    [_EBAccountL sizeToFit];
    [_rechargeNumberL sizeToFit];
    [_statusL sizeToFit];
    [_goldL sizeToFit];
    [_timeL sizeToFit];
}
- (void)copyDealNumber{
    if (_delegate &&[_delegate respondsToSelector:@selector(copydealNumber:)]) {
        [_delegate copydealNumber:_rechargeModel.deal_number];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
