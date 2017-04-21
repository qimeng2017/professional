//
//  LNTabBarVC.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "LNTabBarVC.h"
#import "LNNavigationVC.h"
#import "CurrentForecastViewController.h"
#import "PPMViewController.h"
#import "PersonageViewController.h"
#import "RankListViewController.h"
#import "TriolionViewController.h"
#import "UserStore.h"
#import "LNLottoryConfig.h"
#import "CKAlertViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface LNTabBarVC ()

@end

@implementation LNTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [UITabBar appearance].translucent = NO;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    PPMViewController *vc1 = [[PPMViewController alloc] init];
    [self addChildViewController:vc1 withImage:[UIImage imageNamed:@"tabbar_1"] selectedImage:[UIImage imageNamed:@"tabbar_1_hl"] withTittle:@"上期测中"];

        CurrentForecastViewController *vc2 = [[CurrentForecastViewController alloc] init];
        [self addChildViewController:vc2 withImage:[UIImage imageNamed:@"tabbar_2"] selectedImage:[UIImage imageNamed:@"tabbar_2_hl"] withTittle:@"本期预测"];
    TriolionViewController *vc3 = [[TriolionViewController alloc] init];
    [self addChildViewController:vc3 withImage:[UIImage imageNamed:@"tabbar_3"] selectedImage:[UIImage imageNamed:@"tabbar_3_hl"] withTittle:@"彩讯"];

    RankListViewController *vc4 = [[RankListViewController alloc] init];
    
    [self addChildViewController:vc4 withImage:[UIImage imageNamed:@"tabbar_4"] selectedImage:[UIImage imageNamed:@"tabbar_4_hl"] withTittle:@"排行榜"];
   

        PersonageViewController *vc5 = [[PersonageViewController alloc] init];
      [self addChildViewController:vc5 withImage:[UIImage imageNamed:@"tabbar_5"] selectedImage:[UIImage imageNamed:@"tabbar_5_hl"] withTittle:@"我的"];  
     [self requestCategories];
    // Do any additional setup after loading the view.
}
- (void)addChildViewController:(UIViewController *)controller withImage:(UIImage *)image selectedImage:(UIImage *)selectImage withTittle:(NSString *)tittle{
    UIColor *colorSelect=[UIColor redColor];
    
    LNNavigationVC *nav = [[LNNavigationVC alloc] initWithRootViewController:controller];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav.tabBarItem setImage:image];
    [nav.tabBarItem setSelectedImage:selectImage];
    //    nav.tabBarItem.title = tittle;
    //    controller.navigationItem.title = tittle;
    controller.navigationController.title = tittle;//这句代码相当于上面两句代码
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:colorSelect} forState:UIControlStateSelected];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    [self addChildViewController:nav];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}



- (void)requestCategories{
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UserStore sharedInstance]getCategories:^(NSURLSessionDataTask *task, id responseObject) {
         [SVProgressHUD dismiss];
        NSLog(@"请求成功");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
