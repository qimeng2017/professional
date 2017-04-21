//
//  PPMTableViewCell.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMDataModel.h"

@class PPMTableViewCell;
@protocol PPMTableViewCellDelegate <NSObject>

@optional
- (void)PPMTableViewCell:(PPMTableViewCell *)cell onLookClick:(PPMDataModel*)sender indexPath:(NSIndexPath *)indexPath;
- (void)PPMTableViewCell:(PPMTableViewCell *)cell onUserClick:(PPMDataModel*)sender;//点击用户


@end
@interface PPMTableViewCell : UITableViewCell
@property (nonatomic, strong) PPMDataModel *item;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<PPMTableViewCellDelegate> delegate;
@property (nonatomic, copy) NSString *number;/**<解释*/
@property (nonatomic, copy) NSString *blueball;/**<解释*/
+ (CGFloat)height;
+ (CGFloat)curHeight;
@end
