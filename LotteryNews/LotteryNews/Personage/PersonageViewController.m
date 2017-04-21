//
//  PersonageViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "PersonageViewController.h"
#import <Masonry/Masonry.h>
#import "UserInfoCell.h"
#import "UserStore.h"
#import "LNLottoryConfig.h"
#import "LNUserInfoModel.h"
#import <SVProgressHUD.h>
#import "BuyRecordTableViewController.h"
#import "RechargeTableViewController.h"
#import "LTTableViewController.h"
#import "CKAlertViewController.h"
#import "LNAlertView.h"
#import "ProgressHUD.h"
#import "WYAlertView.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "LNWebViewController.h"
static NSString *const UserInfoCellIdentifier = @"UserInfoCell";
static NSString *const NormalCellIdentifier = @"NormalCell";

@interface PersonageViewController ()<UITableViewDelegate,UITableViewDataSource,UserInfoCellDelegate,WXApiManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray      *titleItems;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView       *viewContent;
@property (nonatomic, strong) LNUserInfoModel *model;
@property (nonatomic, strong) WYAlertView *alert;
@end
CGFloat const footViewHeight = 30;

@implementation PersonageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WXApiManager sharedManager].delegate = self;
     self.navigationTitleView.hidden = YES;
    self.view.backgroundColor = RGBA(246, 246, 246, 1);
    NSString *login_type = UserDefaultObjectForKey(@"login_type");
    NSString *is_bind = UserDefaultObjectForKey(@"is_bind");

        if ([is_bind isEqualToString:@"0"]) {
            if ([login_type isEqualToString:@"1"]) {
                self.titleItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WeixinBind" ofType:@"plist"]];
                
            }else if([login_type isEqualToString:@"0"]){
                self.titleItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PhoneBind" ofType:@"plist"]];
            }else{
                
            }
        }else{
            self.titleItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NoNeedBind" ofType:@"plist"]];
        }

    
    
    self.view.backgroundColor = LRRandomColor;
    [self setBasice];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self getUserInfo];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self debufTest];
    
}
//开发人员可见
- (void)debufTest{
    BOOL review = [[NSUserDefaults standardUserDefaults]boolForKey:LOTTORY_REVIEW_STATUS];
    if (review) {
        NSString *title = @"";
        NSString *sever = UserDefaultObjectForKey(LOTTERY_HOST_NAME_SEVER);
        if ([sever isEqualToString:@"https://caipiao.asopeixun.com:6688"]) {
            title = @"DEBUG";
        }else{
            title = @"RELEASE";
        }
        NSArray *debugs = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DebuggingPersonnel" ofType:@"plist"]];
        NSString *user_id = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
        for (NSString *userId in debugs) {
            if ([userId isEqualToString:user_id]) {
                [self debug:title];
                break;
            }
        }
    }
}
- (void)debug:(NSString *)title{
    UIButton  *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitle:title forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:(134)/255.0f green:(137)/255.0f blue:(141)/255.0f alpha:1] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(debugAction:) forControlEvents:UIControlEventTouchUpInside];\
    [rightButton sizeToFit];\
    rightButton.frame = CGRectMake(0, 0, 80, 44);\
    UIBarButtonItem  *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];\
    self.navigationItem.rightBarButtonItem = rightItem;\
    
}
- (void)debugAction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"DEBUG"]) {
        UserDefaultSetObjectForKey(@"http://120.25.69.28:6689", LOTTERY_HOST_NAME_SEVER);
       
    }else{
        UserDefaultSetObjectForKey(@"https://caipiao.asopeixun.com:6688", LOTTERY_HOST_NAME_SEVER);
    }
    UserDefaultRemoveObjectForKey(LOTTORY_AUTHORIZATION_UID);
    NSArray *arr = [NSArray array];
    NSLog(@"%@",[arr objectAtIndex:11]);
}
//适配
- (void)setBasice{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT-64-tabBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBA(246, 246, 246, 1);
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UserInfoCell class] forCellReuseIdentifier:UserInfoCellIdentifier];
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NormalCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc]init];

    
}

- (void)getUserInfo{
    [SVProgressHUD showWithStatus:@"loading..."];
    NSString *urerId = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    [[UserStore sharedInstance]requestGetUserInfoWithUserId:urerId sucess:^(NSURLSessionDataTask *task, id responseObject) {
        _model = [[LNUserInfoModel alloc]initWithDictionary:responseObject error:nil];
        if ([_model.code isEqualToString:@"1"]) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithDelay:1];
                [self.tableView reloadData];
                
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark -- tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 160;
    
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  _titleItems.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArr = [_titleItems objectAtIndex:section];
        return sectionArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return footViewHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] init];
    footView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, footViewHeight);
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    [footView addSubview:lineView1];
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(0, footViewHeight - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [footView addSubview:lineView2];
    
    if (section==2) {
        [lineView2 removeFromSuperview];
    }
    return footView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionArr = [_titleItems objectAtIndex:indexPath.section];
    NSDictionary *rowDic = [sectionArr objectAtIndex:indexPath.row];
    NSString *title = [rowDic objectForKey:@"title"];
    UIImage *image = [UIImage imageNamed:[rowDic objectForKey:@"imageName"]];
    if (indexPath.section == 0 ) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoCellIdentifier];
        cell.delegate  = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAvatarImage:_model.user_data.images_url Name:_model.user_data.nickname Signature:_model.user_gold];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        
        if (indexPath.section == 3) {
            NSString *login_type = UserDefaultObjectForKey(@"login_type");
            NSString *binSucess = UserDefaultObjectForKey(@"bindSucess");
            if ([login_type isEqualToString:@"1"] &&[binSucess isEqualToString:@"bindSucess"]) {
                title = @"已绑定微信";
            }
            if ([login_type isEqualToString:@"0"] &&[binSucess isEqualToString:@"bindSucess"]) {
                title = @"已绑定手机号";
            }
        }
//        else if(indexPath.section == 2){
//            if (indexPath.row == 0) {
//                title = @"玩法说明";
//            }else if (indexPath.row == 1){
//                title = @"联系我们（客服QQ2585493533)";
//            }
//        }
        cell.textLabel.text = title;
        cell.imageView.image = image;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSArray *setionArr = [_titleItems objectAtIndex:indexPath.section];
    //NSString *title = [setionArr objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
    }else{
        UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:@"签到送金币"]) {
            [self sign];
        }else if ([cell.textLabel.text isEqualToString:@"我的购买"]){
            //我的购买
                        BuyRecordTableViewController *wrVC = [[BuyRecordTableViewController alloc]init];
                        [self pushViewsViewController:wrVC animated:YES];
        }else if ([cell.textLabel.text isEqualToString:@"充值记录"]){
            //            //充值记录
                        RechargeTableViewController *wrVC = [[RechargeTableViewController alloc]init];
                        [self pushViewsViewController:wrVC animated:YES];
        }else if ([cell.textLabel.text isEqualToString:@"玩法说明"]){
            //彩票介绍
                       [self play];
        }else if ([cell.textLabel.text isEqualToString:@"联系我们"]){
                     [self contactUs];
        }else  if ([cell.textLabel.text isEqualToString:@"绑定微信"]) {
                        //
                        [self bindweixin];
        }else if ([cell.textLabel.text isEqualToString:@"绑定手机号"]){
                        [self bindPhone];
                       
        }
    }
}


//签到
- (void)sign{
    NSString *userid = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    [[UserStore sharedInstance]gold_manage:userid task_type:@"2" sucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSString *message = [responseObject objectForKey:@"message"];
        NSInteger code = [codeNum integerValue];
        if (code == 1) {
            [[ProgressHUD sharedInstance]showInfoWithStatus:message];
        }else if(code == 0){
           [[ProgressHUD sharedInstance]showInfoWithStatus:@"今天已经签到了'_'!"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)alertView:(NSString *)title message:(NSString *)message{
    LNAlertView *alertView = [[LNAlertView alloc]initWithTitle:title message: message cancelButtonTitle:@"取消"];
    [alertView addDefaultStyleButtonWithTitle:@"去评论" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
        [alertView dismiss];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:DATE_TO_APPSTORY_BEGIN];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISAPPSTROY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self presentAppstory];
    }];
    
    [alertView show];
    
}


- (void)presentAppstory{
    
    //计时开始
    
    NSString *reviewURL = templateReviewURL ;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        reviewURL = templateReviewURLiOS7;
    }
   
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        reviewURL = templateReviewURLiOS8 ;
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:reviewURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    }
    
}
- (void)applicationBecomeActive{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:ISAPPSTROY]) {
        return;
    }
    NSDate *beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_TO_APPSTORY_BEGIN];
    NSDate *endDate = [NSDate date];
    time_t startTime = (time_t)[beginDate timeIntervalSince1970];
    time_t endTime = (time_t)[endDate timeIntervalSince1970];
    time_t deltaTimeInSeconds = endTime - startTime;
    
    if (deltaTimeInSeconds < 3*60*60) {//3分钟
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ISAPPSTROY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    [self commentForAppstory];
}
//评论成功送金币
- (void)commentForAppstory{
    NSString *userid = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    [[UserStore sharedInstance]gold_manage:userid task_type:@"1" sucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSString *message = [responseObject objectForKey:@"message"];
        NSInteger code = [codeNum integerValue];
        if (code == 1) {
            [[ProgressHUD sharedInstance]showInfoWithStatus:message];
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)pushViewsViewController:(UIViewController *)viewController animated:(BOOL)flag{
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:NO];
}
- (void)recharge{
    LTTableViewController *wrVC = [[LTTableViewController alloc]init];
    [self pushViewsViewController:wrVC animated:YES];
    NSLog(@"充值");
}
- (void)play{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"playDesc" ofType:@"html"];
    
    LNWebViewController *viewCtrl = [[LNWebViewController alloc] initWithURL:[NSURL fileURLWithPath:path]];
    viewCtrl.title = LSTR(@"玩法说明");
    [self pushViewsViewController:viewCtrl animated:NO];
}
- (void)contactUs{
    NSString *sever = UserDefaultObjectForKey(LOTTERY_HOST_NAME_SEVER);
    NSString *url = [NSString stringWithFormat:@"%@/other/aboutus",sever];
    LNWebViewController *viewCtrl = [[LNWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    viewCtrl.title = LSTR(@"联系我们");
    [self pushViewsViewController:viewCtrl animated:NO];
}
- (void)reloadData{
    [self getUserInfo];
    NSLog(@"刷新数据");
}

//绑定手机号
- (void)bindPhone{
    NSString *userid = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    _alert = [[WYAlertView alloc]initWithTitle:@"绑定手机号" message: nil cancelButtonTitle:@"取消" rightButtonTitle:@"绑定" beTextField:YES];
    kWeakSelf(self)
    
    _alert.rightBlock = ^()
    {
        NSLog(@"%@",weakself.alert.text.text);
        [weakself phone:weakself.alert.text.text weixinInfo:nil weixinid:userid];
    };
    [_alert show];
}

//绑定微信
- (void)bindweixin{
    if ([WXApi isWXAppInstalled]) {
        
        [WXApiRequestHandler sendAuthRequestScope:kAuthScope State:kAuthState OpenID:kAuthOpenID InViewController:self];
    }
}
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response{
    if (response.code) {
        [[UserStore sharedInstance] getAccess_token:response.code sucess:^(NSDictionary *dict) {
            NSString *userid = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
            [self phone:userid weixinInfo:dict weixinid:nil];
        }];
        
    }else{
        NSLog(@"微信登录失败");
    }
}
- (void)phone:(NSString *)phoneNumber weixinInfo:(NSDictionary *)wexinDict weixinid:(NSString *)weixinId{
    [[UserStore sharedInstance]account_bind:wexinDict weixinid:weixinId phone:phoneNumber sucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 1) {
            NSString *userid = [responseObject objectForKey:@"userid"];
            UserDefaultSetObjectForKey(userid, LOTTORY_AUTHORIZATION_UID);
            UserDefaultSetObjectForKey(@"bindSucess", @"bindSucess");
            [self getUserInfo];
        }
        [[ProgressHUD sharedInstance]showInfoWithStatus:message];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
   
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
