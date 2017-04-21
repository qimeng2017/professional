//
//  CurrentForecastViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "CurrentForecastViewController.h"
#import "LNLotteryCategories.h"
#import "LottoryCategoryModel.h"
#import "LNLottoryConfig.h"
#import "LiuXSegmentView.h"
#import "LTCurHeaderView.h"
#import "PPMTableViewCell.h"
#import "PPMDataModel.h"
#import "UserStore.h"
#import <CYLTableViewPlaceHolder/CYLTableViewPlaceHolder.h>
#import "XTWithdrawalPlaceHolder.h"
#import "PersonalHomePageViewController.h"
#import "ProgressHUD.h"
#import "SGAlertView.h"
#import "CKAlertViewController.h"
#import "LNAlertView.h"
#import "LTTableViewController.h"
#import <SVProgressHUD.h>
static NSString *currentCellIdentifier = @"currentCellIdentifier";
@interface CurrentForecastViewController ()<UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate,XTWithdrawalPlaceHolderDelegate,PPMTableViewCellDelegate>
@property (nonatomic, strong)NSMutableArray *currentDataArray;
@property (nonatomic, strong)LiuXSegmentView *segement;
@property (nonatomic, strong)LTCurHeaderView *headerView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy) NSString *predictPeriods;

@end

@implementation CurrentForecastViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}
- (NSMutableArray *)currentDataArray{
    if (_currentDataArray == nil) {
        _currentDataArray = [NSMutableArray array];
    }
    return _currentDataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LRRandomColor;
    [self setupBasic];
   
   
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kLotteryDateSuccessedNotification:) name:kLotteryDateSuccessedNotification object:nil];
    [MobClick beginLogPageView:@"CurrentForecastViewController"];
    //[self segmentView:[LNLotteryCategories sharedInstance].categoryPlayArray];
   
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
        if ([LNLotteryCategories sharedInstance].categoryPlayArray.count>0) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self segmentView:[LNLotteryCategories sharedInstance].categoryPlayArray];
            
        }
}

-(void)setupBasic{
    
    
    
    //顶部
    LTCurHeaderView *headerView = [[LTCurHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    
    [self.view addSubview:headerView];
    _headerView = headerView;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, kScreenWidth, CGRectGetHeight(self.view.frame)-94-tabBarHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[PPMTableViewCell class] forCellReuseIdentifier:currentCellIdentifier];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

//滚动
- (void)segmentView:(NSArray *)arr{
    if (_segement) {
        [_segement removeFromSuperview];
    }
    kWeakSelf(self);
    _segement = [[LiuXSegmentView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, 44) segmentType:@"play" titles:arr clickBlick:^(NSInteger index) {
        if (weakself.currentDataArray.count > 0) {
            [weakself.currentDataArray removeAllObjects];
        }
        
        [weakself.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        //NSLog(@"%ld",(long)index);
        LottoryPlaytypemodel *playModel = [arr objectAtIndex:index];
        LottoryCategoryModel *lottoryModel = [LNLotteryCategories sharedInstance].currentLottoryModel;
        [weakself requestLottoryModel:lottoryModel play_type:playModel];
    }];
    
    [self.view addSubview:_segement];
}

- (void)kLotteryDateSuccessedNotification:(NSNotification *)notification{
   
        id value = notification.object;
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            [self segmentView:[LNLotteryCategories sharedInstance].categoryPlayArray];
            
        }
  
    
}

- (void)requestLottoryModel:(LottoryCategoryModel *)lottoryModel play_type:(LottoryPlaytypemodel *)play_type {
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    kWeakSelf(self);
    [[UserStore sharedInstance]request:lottoryModel.caipiaoid play_type:play_type jisu_api_id:lottoryModel.jisu_api_id isNewData:YES sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber *codeNum = [responseObject objectForKey:@"code"];
            NSInteger code = [codeNum integerValue];
            if (code == 1) {
                NSString *title = [responseObject objectForKey:@"title"];
                NSString *message = [responseObject objectForKey:@"message"];
                NSNumber *periods = [responseObject objectForKey:@"open_issueno"];
                NSString *buy_message = [responseObject objectForKey:@"buy_message"];
                _predictPeriods = [NSString stringWithFormat:@"%@",periods];
                [_headerView setTitle:title message:message];
                
                NSArray *dataArr = [responseObject objectForKey:@"data"];
                for (NSDictionary *dict in dataArr) {
                    
                    PPMDataModel *model = [[PPMDataModel alloc]initWithDictionary:dict error:nil];
                    model.caipiaoid = lottoryModel.caipiaoid;
                    model.playtype = play_type.playtype;
                    model.play_type_name = play_type.playtype_name;
                    model.caipiao_name = lottoryModel.caipiao_name;
                    model.buy_message = buy_message;
                    [weakself.currentDataArray addObject:model];
                    
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView cyl_reloadData];
            [SVProgressHUD dismissWithDelay:1];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       // NSLog(@"%@",error);
    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentDataArray.count > indexPath.row) {
        return [PPMTableViewCell curHeight];
    }else{
        return 0;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PPMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:currentCellIdentifier];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_currentDataArray.count > indexPath.row) {
        PPMDataModel *model = [_currentDataArray objectAtIndex:indexPath.row];
        cell.item = model;
        cell.indexPath = indexPath;
        
    }
    
    return cell;
}


#pragma mark -- PPMTableViewCellDelegate
//购买
- (void)PPMTableViewCell:(PPMTableViewCell *)cell onLookClick:(PPMDataModel *)sender indexPath:(NSIndexPath *)indexPath{
    LNAlertView *alertView = [[LNAlertView alloc]initWithTitle:@"提示" message: sender.buy_message cancelButtonTitle:@"取消"];
    [alertView addDefaultStyleButtonWithTitle:@"购买" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
        [alertView dismiss];
        [self sureBuy:cell onLookClick:sender indexPath:indexPath];
    }];
    
    [alertView show];

}
//确认购买
- (void)sureBuy:(PPMTableViewCell *)cell onLookClick:(PPMDataModel *)sender indexPath:(NSIndexPath *)indexPath{
        NSString *userId = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:sender.caipiaoid forKey:@"caipiaoid"];
        [dict setObject:sender.playtype forKey:@"playtype"];
        [dict setObject:_predictPeriods forKey:@"open_issueno"];
        [dict setObject:sender.play_type_name forKey:@"playtype_name"];
        [dict setObject:sender.caipiao_name forKey:@"caipiao_name"];
        [dict setObject:sender.nickname forKey:@"expert_name"];
        [[UserStore sharedInstance]buyExpertData:sender.expert_id userId:userId info:dict sucess:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *codeNum = [responseObject objectForKey:@"code"];
            NSInteger code = [codeNum integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            NSNumber *buyCodeNum = [responseObject objectForKey:@"buy_code"];
            NSInteger buy_code = [buyCodeNum integerValue];
            if (code == 1) {
              
                sender.is_buy = [NSString stringWithFormat:@"%@",buyCodeNum];
                sender.yc_content = [responseObject objectForKey:@"yc_content"];
                NSNumber *isbule = [responseObject objectForKey:@"is_playtype_blue"];
                sender.is_playtype_blue = [NSString stringWithFormat:@"%@",isbule];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self buySucess:cell onLookClick:sender indexPath:indexPath message:message];
                });
                
                
            }
            if (buy_code == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self LackBalance:message];
                });
               
            }else{
                if (code == 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [self buyFailerBuy:cell onLookClick:sender indexPath:indexPath messages:message];
                    });
                   
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
}







//余额不足
- (void)LackBalance:(NSString *)message{
    
    LNAlertView *alertView = [[LNAlertView alloc]initWithTitle:@"提示" message: message cancelButtonTitle:@"取消"];
    [alertView addDefaultStyleButtonWithTitle:@"去充值" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
        [alertView dismiss];
        LTTableViewController *wrVC = [[LTTableViewController alloc]init];
        wrVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wrVC animated:YES];
    }];
    
    [alertView show];
    
    
}
//购买失败
- (void)buyFailerBuy:(PPMTableViewCell *)cell onLookClick:(PPMDataModel *)model indexPath:(NSIndexPath *)indexPath messages:(NSString *)message{
    
    LNAlertView *alertView = [[LNAlertView alloc]initWithTitle:@"提示" message: message cancelButtonTitle:@"取消"];
    [alertView addDefaultStyleButtonWithTitle:@"购买" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
        [alertView dismiss];
         [self sureBuy:cell onLookClick:model indexPath:indexPath];
    }];
    
    [alertView show];
    
}
//购买成功
- (void)buySucess:(PPMTableViewCell *)cell onLookClick:(PPMDataModel *)sender indexPath:(NSIndexPath *)indexPath message:(NSString *)message{
    
    LNAlertView *alertView = [[LNAlertView alloc]initWithTitle:@"提示" message: message cancelButtonTitle:nil];
    [alertView addDefaultStyleButtonWithTitle:@"确定" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
        [alertView dismiss];
        cell.item = sender;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    [alertView show];
    
}


//go 专家主页
- (void)PPMTableViewCell:(PPMTableViewCell *)cell onUserClick:(PPMDataModel *)sender{
    PersonalHomePageViewController *personalHomeVC = [[PersonalHomePageViewController alloc]init];
    personalHomeVC.expert_id = sender.expert_id;
    personalHomeVC.nickname = sender.nickname;
    personalHomeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalHomeVC animated:YES];
}
#pragma mark - MMPopLabelDelegate
///////////////////////////////////////////////////////////////////////////////
- (UIView *)makePlaceHolderView{
    UIView *nodataView = [self weChatStylePlaceHolder];
    return nodataView;
}
#pragma mark -- 无数据时
- (UIView *)weChatStylePlaceHolder {
    XTWithdrawalPlaceHolder*invitationstylePlaceHolder = [[XTWithdrawalPlaceHolder alloc] initWithFrame:self.tableView.frame emptyOverlay:@"正在加载中。。。！" imageView:nil] ;
    invitationstylePlaceHolder.delegate = self;
    return invitationstylePlaceHolder;
}
- (void)emptyOverlayClicked:(id)sender{
    [self.tableView cyl_reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"CurrentForecastViewController"];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
