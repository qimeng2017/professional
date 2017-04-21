//
//  LoginViewController.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "BasicViewController.h"

@protocol LoginViewControllerDelegate <NSObject>

@optional
- (void)userLoginSucess;

@end
@interface LoginViewController : BasicViewController

@property (nonatomic,weak) id<LoginViewControllerDelegate>delegate;
@property (nonatomic, assign) BOOL isFirstPage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView       *viewContent;

@end
