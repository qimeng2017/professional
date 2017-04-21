//
//  PersonalHomePageViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "PersonalHomePageViewController.h"
#import "PHPView.h"
#import "UserStore.h"
#import "HistoryCell.h"
#import "HistoryModel.h"
#import "LNLottoryConfig.h"
#import "CKAlertViewController.h"
#import "LNAlertView.h"
#import "LTTableViewController.h"
#import <SVProgressHUD.h>

static CGFloat headerHeight = 93;


static NSString *const historyCellReuseIdentifier = @"historyCellReuseIdentifier";
static NSString *const notBuyCellReuseIdentifier = @"notBuyCellReuseIdentifier";
@interface PersonalHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,PHPViewDelegate,HistoryCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) BOOL isPage2;
@end

@implementation PersonalHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
   // [self getHomePage];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PersonalHomePageViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setUI{
    PHPView *headerView = [[PHPView alloc]init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, headerHeight);
    headerView.delegate = self;
    headerView.expert_id = _expert_id;
    [self.view addSubview:headerView];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headerHeight, kScreenWidth, SCREEN_HEIGHT-headerHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[HistoryCell class] forCellReuseIdentifier:historyCellReuseIdentifier];
}
//历史预测数据
- (void)getPersonalData:(LottoryCategoryModel *)categoryModel play:(LottoryPlaytypemodel *)playModel{
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UserStore sharedInstance]getexpertData:_expert_id categoryModel:categoryModel playModel:playModel sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        if (code == 1) {
            NSArray *oldArr = [responseObject objectForKey:@"old_data"];
            
            NSDictionary *newDict = [responseObject objectForKey:@"new_data"
                                     ];
            HistoryModel *model = [[HistoryModel alloc]initWithDictionary:newDict error:nil];
            model.play_type_name = playModel.playtype_name;
            model.caipiaoid = categoryModel.caipiaoid;
            model.playtype = playModel.playtype;
            model.caipiao_name = categoryModel.caipiao_name;
            [self.dataArray addObject:model];
            for (NSDictionary *dict in oldArr) {
                HistoryModel *model = [[HistoryModel alloc]initWithDictionary:dict error:nil];
                model.play_type_name = playModel.playtype_name;
                model.caipiaoid = categoryModel.caipiaoid;
                model.playtype = playModel.playtype;
                model.caipiao_name = categoryModel.caipiao_name;
                [self.dataArray addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [SVProgressHUD dismissWithDelay:1];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark--tableview delegate   dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > indexPath.row) {
        HistoryModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if (model.message) {
            return 70;
        }else{
            return 100;
        }
    }else{
        return 0;
    }
   
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCellReuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (self.dataArray.count > indexPath.row) {
        HistoryModel *model = [self.dataArray objectAtIndex:indexPath.row];
        cell.historyModel =model;
        cell.indexPath = indexPath;
    }
    
    return cell;
}
- (void)HistoryTableViewCell:(HistoryCell *)cell buyModel:(HistoryModel *)model indexPath:(NSIndexPath *)indexPath{
    
    LNAlertView *alertView = [[LNAlertView alloc]initWithTitle:@"提示" message: model.message cancelButtonTitle:@"取消"];
    [alertView addDefaultStyleButtonWithTitle:@"购买" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
        [alertView dismiss];
        [self sureBuy:cell onLookClick:model indexPath:indexPath];
    }];
    
    [alertView show];
}

//确认购买
- (void)sureBuy:(HistoryCell *)cell onLookClick:(HistoryModel *)model indexPath:(NSIndexPath *)indexPath{
    
    
    NSString *userId = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:model.caipiaoid forKey:@"caipiaoid"];
    [dict setObject:model.playtype forKey:@"playtype"];
    [dict setObject:model.issueno forKey:@"open_issueno"];
    [dict setObject:model.play_type_name forKey:@"playtype_name"];
    [dict setObject:model.caipiao_name forKey:@"caipiao_name"];
    [dict setObject:_nickname forKey:@"expert_name"];
    [[UserStore sharedInstance]buyExpertData:_expert_id userId:userId info:dict sucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        NSString *message = [responseObject objectForKey:@"message"];
        NSNumber *buyCodeNum = [responseObject objectForKey:@"buy_code"];
        NSInteger buy_code = [buyCodeNum integerValue];
        if (code == 1) {
            HistoryCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            HistoryModel *model = [self.dataArray objectAtIndex:indexPath.row];
            model.yc_content = [responseObject objectForKey:@"yc_content"];
            NSNumber *isbule = [responseObject objectForKey:@"is_playtype_blue"];
            model.is_playtype_blue = [NSString stringWithFormat:@"%@",isbule];
            model.is_buy = [NSString stringWithFormat:@"%@",buyCodeNum];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self buySucess:cell onLookClick:model indexPath:indexPath message:message];
            });
            
        }
        if (buy_code == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self LackBalance:message];
            });
            
        }else{
            if (code == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self buyFailerBuy:cell onLookClick:model indexPath:indexPath messages:message];
                });
                
            }
        }

        NSLog(@"code====%ld",(long)code);
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
- (void)buyFailerBuy:(HistoryCell *)cell onLookClick:(HistoryModel *)model indexPath:(NSIndexPath *)indexPath messages:(NSString *)message{
    
    LNAlertView *alertView = [[LNAlertView alloc]initWithTitle:@"提示" message: message cancelButtonTitle:@"取消"];
    [alertView addDefaultStyleButtonWithTitle:@"重试" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
        [alertView dismiss];
       [self sureBuy:cell onLookClick:model indexPath:indexPath];
    }];
    
    [alertView show];
   
}
//购买成功
- (void)buySucess:(HistoryCell *)cell onLookClick:(HistoryModel *)sender indexPath:(NSIndexPath *)indexPath message:(NSString *)message{
    
    LNAlertView *alertView = [[LNAlertView alloc]initWithTitle:@"提示" message: message cancelButtonTitle:nil];
    [alertView addDefaultStyleButtonWithTitle:@"确定" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
        [alertView dismiss];
        cell.historyModel = sender;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self ios_ad_manage];
    }];
    
    [alertView show];
    
}
- (void)ios_ad_manage{
    NSString *userid = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    [[UserStore sharedInstance]ios_ad_manage:userid sucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *code = [responseObject objectForKey:@"code"];
        NSInteger codeInteger = [code integerValue];
        NSNumber *mode = [responseObject objectForKey:@"mode"];
        NSInteger modeInteger = [mode integerValue];
        NSString *title = [responseObject objectForKey:@"title"];
        NSString *message = [responseObject objectForKey:@"message"];
        NSString * download_url = [responseObject objectForKey:@"download_url"];
        if (codeInteger==1) {
            
            if (modeInteger==0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [self accordingUpdate:title content:message downloadURL:download_url type:YES];
                });
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self accordingUpdate:title content:message downloadURL:download_url type:NO];
                });
                
            }
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)accordingUpdate:(NSString *)title content:(NSString *)message downloadURL:(NSString *)downloadUrl type:(BOOL)isAccord{
    LNAlertView *alertView = [[LNAlertView alloc]initWithTitle:title message: message cancelButtonTitle:nil];
    //强制去下载
    if (isAccord) {
        [alertView addDefaultStyleButtonWithTitle:@"去下载" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
            [alertView dismiss];
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
            
        }];
    }else{
        [alertView addDefaultStyleButtonWithTitle:@"取消" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
            [alertView dismiss];
            
        }];
        [alertView addDefaultStyleButtonWithTitle:@"去下载" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
            [alertView dismiss];
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
        }];
    }
    
     [alertView show];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"PersonalHomePageViewController"];
}

@end
