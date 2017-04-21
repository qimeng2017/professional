//
//  LTPreHeaderView.h
//  Lottery
//
//  Created by quentin on 16/5/16.
//  Copyright © 2016年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTPreHeaderView;

@protocol LTPreHeaderViewDelegate <NSObject>

- (void)LTPreHeaderView:(LTPreHeaderView *)headerView onPlayDesClick:(id)sender;//点击玩法说明

@end

@interface LTPreHeaderView : UIView

@property (nonatomic, weak) id<LTPreHeaderViewDelegate> delegate;/**<LTPreHeaderViewDelegate*/

@property (nonatomic, copy) NSString *number;/**<解释*/
@property (nonatomic, copy) NSString *blueball;/**<解释*/
@property (nonatomic, copy) NSString *open_issueno;
- (void)setNumber:(NSString *)number blueball:(NSString *)blueball open_issueno:(NSString *)open_issueno;
+ (CGFloat)height;

@end
