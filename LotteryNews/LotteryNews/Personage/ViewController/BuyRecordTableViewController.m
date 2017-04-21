//
//  BuyRecordTableViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "BuyRecordTableViewController.h"
#import "UserStore.h"
#import "BuyRecordModel.h"
#import "BuyRecordCell.h"
#import "LNLottoryConfig.h"
#import <CYLTableViewPlaceHolder/CYLTableViewPlaceHolder.h>
#import "XTWithdrawalPlaceHolder.h"
#import "PersonalHomePageViewController.h"
#import <SVProgressHUD.h>
static NSString *const buyRecordCellReuseIdentifier = @"buyRecordCellReuseIdentifier";
@interface BuyRecordTableViewController ()<CYLTableViewPlaceHolderDelegate>
@property (nonatomic, strong)NSMutableArray *buyRecordArr;
@end

@implementation BuyRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的购买";
    [self initUI];
    [self getBuyRecordData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"BuyRecordTableViewController"];
}
- (NSMutableArray *)buyRecordArr{
    if (_buyRecordArr == nil) {
        _buyRecordArr = [NSMutableArray array];
    }
   return  _buyRecordArr;
}
- (void)initUI{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BuyRecordCell class]) bundle:nil] forCellReuseIdentifier:buyRecordCellReuseIdentifier];
    self.tableView.tableFooterView = [[UIView alloc]init];
    // cell的高度设置
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
- (void)getBuyRecordData{
    [SVProgressHUD showWithStatus:@"Load..."];
    NSString *userid = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    [[UserStore sharedInstance]getBuyRecord:userid sucess:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        if (code == 1) {
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            for (NSDictionary *dict in dataArr) {
                BuyRecordModel *model = [[BuyRecordModel alloc]initWithDictionary:dict error:nil];
                [self.buyRecordArr addObject:model];
            }
        }
        
        //NSLog(@"%@",responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView  cyl_reloadData];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.buyRecordArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:buyRecordCellReuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.buyRecordArr.count > indexPath.row) {
        cell.buyModel = [self.buyRecordArr objectAtIndex:indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_buyRecordArr.count > indexPath.row) {
        BuyRecordModel *buyModel = [self.buyRecordArr objectAtIndex:indexPath.row];
        PersonalHomePageViewController *personalHomeVC = [[PersonalHomePageViewController alloc]init];
        personalHomeVC.expert_id = buyModel.expert_id;
        personalHomeVC.nickname = buyModel.expert_name;
        personalHomeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personalHomeVC animated:YES];
    }
    
}
//无数据时
- (UIView *)makePlaceHolderView{
    XTWithdrawalPlaceHolder *placeHolder = [[XTWithdrawalPlaceHolder alloc]initWithFrame:self.tableView.frame emptyOverlay:@"你还没有任何购买记录" imageView: nil];
    return placeHolder;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"BuyRecordTableViewController"];
}
@end
