//
//  TriolionViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "TriolionViewController.h"
#import "LottoryCategoryModel.h"
#import "LNLotteryCategories.h"
#import <MJRefresh/MJRefresh.h>
#import "UserStore.h"
#import "LiuXSegmentView.h"
#import "TriolionModel.h"
#import "TriolionCell.h"

#import "LNWebViewController.h"

#import "LNLottoryConfig.h"
#import <SVProgressHUD.h>
static NSString *triolionCellCellWithIdentifier = @"triolionCellCellWithIdentifier";
@interface TriolionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) LottoryCategoryModel *categoryModel;

@end

@implementation TriolionViewController
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = LRRandomColor;
    [self configUI];
    //self.navigationTitleView.hidden = YES;
    
    // Do any additional setup after loading the view.
}
- (void)configUI{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT-kTabBarH-kStatusBarH-kNavigationBarH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.rowHeight =  UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 50;//必须设置好预估值
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TriolionCell class]) bundle:nil] forCellReuseIdentifier:triolionCellCellWithIdentifier];
    LottoryCategoryModel *caModel=  [LNLotteryCategories sharedInstance].currentLottoryModel;
    _categoryModel = caModel;
    
    [self refreshHeader];
    [self refreshFooter];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kLotteryDataCategoryNotification:) name:kLotteryDataCategoryNotification object:nil];
    [MobClick beginLogPageView:@"TriolionViewController"];
}


- (void)refreshHeader{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置刷新控件
    self.tableView.mj_header = header;
     self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

- (void)refreshFooter{
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置文字
    [footer setTitle:@"点击或上拉刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor  grayColor];
    footer.automaticallyHidden = YES;
    footer.automaticallyRefresh = NO;
    // 设置footer
    self.tableView.mj_footer = footer;
}


- (void)kLotteryDataCategoryNotification:(NSNotification *)notification{
    id value = notification.object;
    if ([value isKindOfClass:[LottoryCategoryModel class]]) {
        _categoryModel = (LottoryCategoryModel *)value;
        [self loadNewData];
    }
}
- (void)loadNewData{
    _currentPage = 1;
    [self loadData:ScrollDirectionDown];
}
- (void)loadMoreData{
    _currentPage += 1;
    [self loadData:ScrollDirectionUp];
}
- (void)loadData:(ScrollDirection)direction{
    [SVProgressHUD showWithStatus:@"Loading..."];
    kWeakSelf(self);
    [[UserStore sharedInstance] newsCategory:_categoryModel.caipiaoid page:_currentPage sucess:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        if (code == 1) {
            NSArray *datas = [responseObject objectForKey:@"data"];
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSDictionary *dict in datas) {
                TriolionModel *model = [[TriolionModel alloc]initWithDictionary:dict error:nil];
                [arrayM addObject:model];
                
            }
            if (direction == ScrollDirectionDown) {
                weakself.dataArray = [arrayM mutableCopy];
            }else{
                [weakself.dataArray addObjectsFromArray:arrayM];
            }
        }else{
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            weakself.tableView.mj_footer.hidden = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithDelay:1];
            if (direction == ScrollDirectionDown) {
                
                [weakself.tableView.mj_header endRefreshing];
                [weakself.tableView reloadData];
            }else if(direction == ScrollDirectionUp){
                
                [weakself.tableView reloadData];
                [weakself.tableView.mj_footer endRefreshing];
                
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TriolionCell *cell = [tableView dequeueReusableCellWithIdentifier:triolionCellCellWithIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArray.count > indexPath.row) {
        TriolionModel *model = [self.dataArray objectAtIndex:indexPath.row];
        cell.triolionModel = model;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count > indexPath.row) {
        TriolionModel *model = [self.dataArray objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:model.url];
        LNWebViewController *web = [[LNWebViewController alloc]initWithURL:url];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:NO];
    }
    
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
    [MobClick endLogPageView:@"TriolionViewController"];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
