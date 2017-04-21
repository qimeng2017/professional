//
//  RechargeRecordCell.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeRecordModel.h"

@protocol RechargeRecordCellDelegate <NSObject>

- (void)copydealNumber:(NSString *)dealNumber;

@end
@interface RechargeRecordCell : UITableViewCell
@property (nonatomic,weak)id<RechargeRecordCellDelegate>delegate;
@property (nonatomic, strong)RechargeRecordModel *rechargeModel;
@end
