//
//  LTCurHeaderView.h
//  Lottery
//
//  Created by quentin on 16/5/17.
//  Copyright © 2016年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTCurHeaderView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
+ (CGFloat)height;
- (void)setTitle:(NSString *)title message:(NSString *)message;
@end
