//
//  PHPView.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LottoryCategoryModel.h"
#import "LottoryPlaytypemodel.h"
@protocol PHPViewDelegate <NSObject>

- (void)getPersonalData:(LottoryCategoryModel *)categoryModel play:(LottoryPlaytypemodel *)playModel;

@end
@interface PHPView : UIView
@property (nonatomic, weak)id<PHPViewDelegate>delegate;
@property (nonatomic,strong)NSString *nickName;
@property (nonatomic, strong)NSString *introducetion;
@property (nonatomic, copy) NSString *expert_id;

@end
