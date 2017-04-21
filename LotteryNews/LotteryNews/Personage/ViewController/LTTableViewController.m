//
//  LTTableViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "LTTableViewController.h"
#import "SGActionSheet.h"
#import "LNActionSheetView.h"
#import "UserStore.h"
#import "LNLottoryConfig.h"
#import "StoreManager.h"
#import "ProgressHUD.h"
#import <SVProgressHUD.h>
@class LTPayCell;

@protocol LTPayCellDelegate <NSObject>

- (void)LTPayCell:(LTPayCell *)cell onPayClick:(id)sender;

@end

@interface LTPayCell : UITableViewCell

{
    UIButton  *_payCashButton;//pay cash
}

@property (nonatomic, strong) NSDictionary *payDict;
@property (nonatomic, weak) id<LTPayCellDelegate> delegate;

+ (CGFloat)height;

@end

@implementation LTPayCell
@synthesize delegate;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customInit];
    }
    return self;
}
- (void)customInit
{
    self.backgroundColor = [UIColor whiteColor];
    
    //pay
    UIImage *image = [UIImage imageNamed:@"choosenumber_bg"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    
    _payCashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payCashButton setBackgroundImage:image forState:UIControlStateNormal];
    _payCashButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_payCashButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_payCashButton addTarget:self action:@selector(onPayClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_payCashButton];
}

- (void)setPayDict:(NSDictionary *)payDict
{
    _payDict = payDict;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_payCashButton setTitle:[_payDict objectForKey:@"describe"] forState:UIControlStateNormal];
    
    CGFloat x = 15;
    CGFloat height = 45;
    
    
    _payCashButton.frame = CGRectMake(x, (CGRectGetHeight(self.frame) - height) / 2, CGRectGetWidth(self.frame) - x * 2, height);
}

+ (CGFloat)height
{
    return 60;
}

#pragma mark - on click

- (void)onPayClick:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(LTPayCell:onPayClick:)]) {
        [delegate LTPayCell:self onPayClick:sender];
    }
}

@end
@interface LTTableViewController ()<LTPayCellDelegate,IApRequestResultsDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSDictionary *payDict;
@end

@implementation LTTableViewController
@synthesize items;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    [StoreManager sharedInstance].delegate = self;
    UIView *headerView = [[UIView alloc] init];
    
    NSString *title = LSTR(@"金币说明，金币不可购买彩票，仅用于购买专家预测，购买后不可提现或退款。专家不保证100%准确");
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = title;
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.textColor = [UIColor grayColor];
    headerLabel.numberOfLines = 0;
    [headerView addSubview:headerLabel];
    
    CGFloat x = 15;
    CGFloat y = 10;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) -  x * 2, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : headerLabel.font} context:NULL];
    headerLabel.frame = CGRectMake(x, y, CGRectGetWidth(self.view.frame) - x * 2, CGRectGetHeight(rect));
    
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(rect) + y * 2);
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.items = kStoreList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [[StoreManager sharedInstance]startManager];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    LTPayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[LTPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.items.count > indexPath.row) {
        NSDictionary *dict = [self.items objectAtIndex:indexPath.row];
        cell.payDict = dict;
    }
    
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LTPayCell height];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    //[self sheet:dict];
}
#pragma mark - LTPayCellDelegate

- (void)LTPayCell:(LTPayCell *)cell onPayClick:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading..."];
    NSDictionary *dict = cell.payDict;
    NSString *product_id = [dict objectForKey:@"product_id"];
    
    [[StoreManager sharedInstance]requestProductWithId:product_id];
   // [self sheet:dict];
}



#pragma mark IApRequestResultsDelegate
- (void)filedWithSucessCode:(NSString *)message{
    [self message:message];
    [SVProgressHUD dismiss];
}
- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error {
    [SVProgressHUD dismiss];
    switch (errorCode) {
        case IAP_FILEDCOED_APPLECODE:
            [self message:error];
            NSLog(@"用户禁止应用内付费购买:%@",error);
            break;
            
        case IAP_FILEDCOED_NORIGHT:
            [self message:@"用户禁止应用内付费购买"];
            
            break;
            
        case IAP_FILEDCOED_EMPTYGOODS:
           
            [self message:@"商品为空"];
            break;
            
        case IAP_FILEDCOED_CANNOTGETINFORMATION:
            
            [self message:@"无法获取产品信息，请重试"];
            break;
            
        case IAP_FILEDCOED_BUYFILED:
            [self message:@"购买失败，请重试"];
            
            break;
            
        case IAP_FILEDCOED_USERCANCEL:
            [self message:@"用户取消交易"];
    
            break;
        case IAP_FILEDCOED_VALIDATION:
            [self message:@"购买失败，未通过验证！"];
            break;
        default:
            break;
    }
}
- (void)message:(NSString *)message{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ProgressHUD sharedInstance]showInfoWithStatus:message];
    });
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
