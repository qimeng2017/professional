//
//  RechargeTableViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "RechargeTableViewController.h"
#import "RechargeRecordCell.h"
#import "RechargeRecordModel.h"
#import "UserStore.h"
#import "LNLottoryConfig.h"

#import "ProgressHUD.h"

#import <CYLTableViewPlaceHolder/CYLTableViewPlaceHolder.h>
#import "XTWithdrawalPlaceHolder.h"

#import <SVProgressHUD.h>
static NSString *const RechargeRecordCellReuseIdentifier = @"RechargeRecordCellReuseIdentifier";
@interface RechargeTableViewController ()<RechargeRecordCellDelegate,CYLTableViewPlaceHolderDelegate>
@property (nonatomic, strong) NSMutableArray *rechargeDataArr;
@end

@implementation RechargeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值记录";
    [self initUI];
    [self getRechargeRcordData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RechargeTableViewController"];
}
- (void)initUI{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RechargeRecordCell class]) bundle:nil] forCellReuseIdentifier:RechargeRecordCellReuseIdentifier];
    self.tableView.tableFooterView = [[UIView alloc]init];
    // cell的高度设置
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
- (NSMutableArray *)rechargeDataArr{
    if (_rechargeDataArr == nil) {
        _rechargeDataArr = [NSMutableArray array];
    }
    return _rechargeDataArr;
}
- (void)getRechargeRcordData{
    kWeakSelf(self);
    [SVProgressHUD showWithStatus:@"Load..."];
    NSString *userid = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    [[UserStore sharedInstance]getRechargeRecord:userid sucess:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        //NSString *message = [responseObject objectForKey:@"message"];
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        if (code == 1) {
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            for (NSDictionary *dict in dataArr) {
              RechargeRecordModel *model = [[RechargeRecordModel alloc]initWithDictionary:dict error:nil];
                [weakself.rechargeDataArr addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView cyl_reloadData];
        });
        //NSLog(@"%@",responseObject);
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

    return self.rechargeDataArr.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:RechargeRecordCellReuseIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.rechargeDataArr.count > indexPath.row) {
      RechargeRecordModel *model = [self.rechargeDataArr objectAtIndex:indexPath.row];
        cell.rechargeModel = model;
    }
    cell.delegate  =self;
    
    return cell;
}
//无数据时
- (UIView *)makePlaceHolderView{
    XTWithdrawalPlaceHolder *placeHolder = [[XTWithdrawalPlaceHolder alloc]initWithFrame:self.tableView.frame emptyOverlay:@"你还没有任何充值记录" imageView: nil];
    return placeHolder;
}

//复制订单号
- (void)copydealNumber:(NSString *)dealNumber{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = dealNumber;
    [[ProgressHUD sharedInstance]showErrorOrSucessWithStatus:NO message:@"订单号复制成功"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"RechargeTableViewController"];
}

@end
