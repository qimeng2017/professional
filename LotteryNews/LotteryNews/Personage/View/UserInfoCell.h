//
//  UserInfoCell.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserInfoCellDelegate <NSObject>

- (void)recharge;
- (void)reloadData;

@end
@interface UserInfoCell : UITableViewCell
@property (nonatomic, weak)id<UserInfoCellDelegate>delegate;
- (void)setAvatarImage:(NSString *)image Name:(NSString *)name Signature:(NSString *)content;
@end
