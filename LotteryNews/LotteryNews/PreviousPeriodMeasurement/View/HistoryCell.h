//
//  HistoryCell.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/27.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"

@class HistoryCell;
@protocol HistoryCellDelegate <NSObject>

- (void)HistoryTableViewCell:(HistoryCell *)cell buyModel:(HistoryModel *)model indexPath:(NSIndexPath *)indexPath;

@end
@interface HistoryCell : UITableViewCell
@property (nonatomic, weak)id<HistoryCellDelegate>delegate;
@property (nonatomic, strong)HistoryModel *historyModel;
@property (nonatomic, copy) NSString *number;/**<解释*/
@property (nonatomic, copy) NSString *blueball;/**<解释*/
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong)NSIndexPath *indexPath;
@end
