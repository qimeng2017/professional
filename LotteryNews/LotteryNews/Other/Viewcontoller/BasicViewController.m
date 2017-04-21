//
//  BasicViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "BasicViewController.h"

#import "LNLotteryCategories.h"
#import "LNLottoryConfig.h"
#import "LottoryCategoryModel.h"
#import "UserStore.h"
#import "LottoryPlaytypemodel.h"

#define kNavigationOpen YES//是否为显示全部lottery类型,如果为YES则显示所有的类型，为NO则为单独的
@interface BasicViewController ()<TopMenuViewDelegate>
{
    UIButton               *_navButton;
    
}

@end

@implementation BasicViewController
@synthesize navigationTitle;
+ (BasicViewController *)sharedInstance
{
    static BasicViewController *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BasicViewController alloc] init];
    });
    
    return _sharedInstance;
}
- (id)init{
    self = [super init];
    if (self) {
      //[self requestCategories];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"大乐透" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 120, 44.f);
    
    if (kNavigationOpen) {
        [button setImage:[UIImage imageNamed:@"grrow_down"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onPopverClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame))];
    [titleView addSubview:button];
    self.navigationItem.titleView = titleView;
    _navigationTitleView = titleView;
    _navButton = button;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  LottoryCategoryModel *caModel=  [LNLotteryCategories sharedInstance].currentLottoryModel;
    if (caModel) {
        [_navButton setTitle:caModel.caipiao_name forState:UIControlStateNormal];
        [self requestPlayType:caModel];
    }
    if ([LNLotteryCategories sharedInstance].categoryArray.count > 0) {
       [self.view addSubview:self.ninaSelectionView];
    }
}
- (void)kLotteryDateSuccessedFirstNotifications:(NSNotification *)notification{
    id value = notification.object;
    if ([value isKindOfClass:[NSArray class]]) {
         NSArray *arr = (NSArray *)value;
        //当前类别
        LottoryCategoryModel *model = [arr objectAtIndex:1];
        [LNLotteryCategories sharedInstance].currentLottoryModel = model;
        [LNLotteryCategories sharedInstance].categoryArray = arr;
        [_navButton setTitle:model.caipiao_name forState:UIControlStateNormal];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self.ninaSelectionView];
        });
        [self requestPlayType:model];
    }
}

#pragma mark - LazyLoad

- (TopMenuView *)ninaSelectionView {
  
    if (!_topMenuView) {
        _topMenuView = [[TopMenuView alloc] initWithTitles:[LNLotteryCategories sharedInstance].categoryArray PopDirection:NinaPopFromAboveToTop];
        _topMenuView.ninaSelectionDelegate = self;
        _topMenuView.defaultSelected = [LNLotteryCategories sharedInstance].categorySelectedIndex? [LNLotteryCategories sharedInstance].categorySelectedIndex:2;
        _topMenuView.shadowEffect = YES;
        _topMenuView.shadowAlpha = 0.5;
    }
    return _topMenuView;
}
- (void)onPopverClick:(id)sender{
    _topMenuView.defaultSelected = [LNLotteryCategories sharedInstance].categorySelectedIndex? [LNLotteryCategories sharedInstance].categorySelectedIndex:2;
     [self.topMenuView showOrDismissNinaViewWithDuration:0.5 usingNinaSpringWithDamping:0.8 initialNinaSpringVelocity:0.3];
}
#pragma mark - SelectionDelegate
- (void)selectNinaAction:(UIButton *)button {
    //NSLog(@"Choose %li button",(long)button.tag);
   
    [LNLotteryCategories sharedInstance].currentLottoryModel = [[LNLotteryCategories sharedInstance].categoryArray objectAtIndex:button.tag-1];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLotteryDataCategoryNotification object:[LNLotteryCategories sharedInstance].currentLottoryModel];
   NSString *changeStr = button.titleLabel.text;
    [_navButton setTitle:changeStr forState:UIControlStateNormal];
    [self requestPlayType:[LNLotteryCategories sharedInstance].currentLottoryModel];
    [LNLotteryCategories sharedInstance].categorySelectedIndex = button.tag;
    _topMenuView.defaultSelected = [LNLotteryCategories sharedInstance].categorySelectedIndex? [LNLotteryCategories sharedInstance].categorySelectedIndex:2;
    [self.ninaSelectionView showOrDismissNinaViewWithDuration:0.3];
    
}
- (void)requestPlayType:(LottoryCategoryModel *)model{
   
    [[UserStore sharedInstance] requestPlayType:model sucess:^(NSURLSessionDataTask *task, id responseObject) {
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
