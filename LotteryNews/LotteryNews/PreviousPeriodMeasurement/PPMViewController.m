//
//  PPMViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "PPMViewController.h"
#import "LottoryCategoryModel.h"
#import "LNLotteryCategories.h"
#import "LNLottoryConfig.h"
#import "LottoryPlaytypemodel.h"
#import "LiuXSegmentView.h"
#import "PPMDataModel.h"
#import "PPMTableViewCell.h"
#import "LTPreHeaderView.h"
#import "LNWebViewController.h"
#import "UserStore.h"
#import "PersonalHomePageViewController.h"
#import "CKAlertViewController.h"
#import <SVProgressHUD.h>
static NSString *ppmCellIdentifier = @"ppmCellIdentifier";
@interface PPMViewController ()<UITableViewDelegate,UITableViewDataSource,LTPreHeaderViewDelegate,PPMTableViewCellDelegate>
@property (nonatomic, strong)LottoryCategoryModel *categoryModel;
@property (nonatomic, strong)LiuXSegmentView *segement;
@property (nonatomic, strong)NSMutableArray *ppmDataArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)LTPreHeaderView *headerView;
@end

@implementation PPMViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LRRandomColor;
    
    [self setupBasic];
 
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)ppmDataArray{
    if (_ppmDataArray == nil) {
        _ppmDataArray = [NSMutableArray array];
    }
    return _ppmDataArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kLotteryDateSuccessedNotifications:) name:kLotteryDateSuccessedNotification object:nil];
    [MobClick beginLogPageView:@"PPMViewController"];
    
    
   
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   
    
}

-(void)setupBasic{
   
    
    
    //顶部
    LTPreHeaderView *headerView = [[LTPreHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];
    headerView.delegate = self;
    [self.view addSubview:headerView];
    _headerView = headerView;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, kScreenWidth, CGRectGetHeight(self.view.frame)-104-tabBarHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
     [self.tableView registerClass:[PPMTableViewCell class] forCellReuseIdentifier:ppmCellIdentifier];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark --数据
- (void)kLotteryDateSuccessedNotifications:(NSNotification *)notification{
    id value = notification.object;
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)value;
        _categoryModel = [dict objectForKey:@"category"];
        NSArray *playArr = [dict objectForKey:@"playtype"];
        [self segmentView:playArr];
    }
}
- (void)segmentView:(NSArray *)arr{
    if (_segement) {
        [_segement removeFromSuperview];
    }
    kWeakSelf(self);
    _segement = [[LiuXSegmentView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, 44) segmentType:@"play" titles:arr clickBlick:^(NSInteger index) {
        if (self.ppmDataArray.count > 0) {
            [self.ppmDataArray removeAllObjects];
        }
        [weakself.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        NSLog(@"%ld",(long)index);
        LottoryPlaytypemodel *playModel = [arr objectAtIndex:index];
        [weakself request:_categoryModel.caipiaoid play_type:playModel jisu_api_id:_categoryModel.jisu_api_id];
    }];
    
    [self.view addSubview:_segement];
}
- (void)request:(NSString *)caipiaoid play_type:(LottoryPlaytypemodel *)play_type jisu_api_id:(NSString *)jisu_api_id{
   
    [SVProgressHUD showWithStatus:@"Loading..."];
    kWeakSelf(self);
    
    [[UserStore sharedInstance]request:caipiaoid play_type:play_type jisu_api_id:jisu_api_id isNewData:NO sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber *codeNum = [responseObject objectForKey:@"code"];
            NSInteger code = [codeNum integerValue];
            if (code == 1) {
                NSString *number = [responseObject objectForKey:@"number"];
                NSString *blueball = [responseObject objectForKey:@"blueball"];
                NSNumber *open_issuenoNum = [responseObject objectForKey:@"open_issueno"];
                NSString *open_issueno = [NSString stringWithFormat:@"%@",open_issuenoNum];
                [_headerView setNumber:number blueball:blueball open_issueno:open_issueno];
                NSArray *dataArr = [responseObject objectForKey:@"data"];
                for (NSDictionary *dict in dataArr) {
                    
                    PPMDataModel *model = [[PPMDataModel alloc]initWithDictionary:dict error:nil];
//                    model.fore_data = [dict objectForKey:@"fore_data"];
//                    model.nickname = [dict objectForKey:@"nickname"];
//                    model.yc_content = [dict objectForKey:@"yc_content"];
//                    NSNumber *expertidNum = [dict objectForKey:@"expert_id"];
//                    model.expert_id = [NSString stringWithFormat:@"%@",expertidNum];
//                    model.isLook = NO;
//                    model.yc_status = [dict objectForKey:@"yc_status"];
//                    model.play_type = play_type.playtype_name;
                    [weakself.ppmDataArray addObject:model];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
            [SVProgressHUD dismissWithDelay:1];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)LTPreHeaderView:(LTPreHeaderView *)headerView onPlayDesClick:(id)sender{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"playDesc" ofType:@"html"];
    
    LNWebViewController *viewCtrl = [[LNWebViewController alloc] initWithURL:[NSURL fileURLWithPath:path]];
    viewCtrl.title = LSTR(@"玩法说明");
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:NO];
}














#pragma mark--tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  [PPMTableViewCell curHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ppmDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PPMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ppmCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_ppmDataArray.count > indexPath.row) {
        PPMDataModel *model = [_ppmDataArray objectAtIndex:indexPath.row];
        cell.item = model;
    }
    cell.delegate = self;
    return cell;
}
- (void)PPMTableViewCell:(PPMTableViewCell *)cell onUserClick:(PPMDataModel *)sender{
    PersonalHomePageViewController *personalHomeVC = [[PersonalHomePageViewController alloc]init];
    personalHomeVC.expert_id = sender.expert_id;
    personalHomeVC.nickname = sender.nickname;
    personalHomeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalHomeVC animated:YES];
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
    [MobClick endLogPageView:@"PPMViewController"];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
