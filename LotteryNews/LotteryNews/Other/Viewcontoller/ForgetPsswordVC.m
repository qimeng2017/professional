//
//  ForgetPsswordVC.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "ForgetPsswordVC.h"
#import "ControlsView.h"
@interface ForgetPsswordVC ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UITextField  *phoneNumText;
@property (nonatomic,strong) UILabel      *phoneNumLineLabel;
@property (nonatomic,strong) UITextField  *loginPasswordText;
@property (nonatomic,strong) UITextField  *getVerifiText;
@property (nonatomic,strong) UIButton     *getVerifiBtn;
@property (nonatomic,strong) UILabel      *getVerifiLabel;
@property (nonatomic,strong) UITextField  *passWordText;
@property (nonatomic,strong) UILabel      *paaWordLabel;
@property (nonatomic,strong) UIButton     *completeBtn;
@property (nonatomic,strong) UIScrollView *forgetScrollowVctrl;
@property (nonatomic,strong) UILabel      *registVerfiLable;
@end

@implementation ForgetPsswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    [self createBtn];
    UIBarButtonItem *forgetLeftItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Group 10.png"] style:UIBarButtonItemStyleDone target:self action:@selector(forgetLeftItem:)];
    self.navigationItem.leftBarButtonItem = forgetLeftItem;
    // 去消息通知中心订阅一条消息（当键盘将要显示时UIKeyboardWillShowNotification）执行相应的方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forgetKeyBoardWillShowWordVctrl:) name:UIKeyboardWillShowNotification object:nil];
    // 去消息通知中心订阅一条消息（当键盘将要隐藏时UIKeyboardWillHideNotification）执行相应的方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forgetKeyBoardWillHideWordVctrl:) name:UIKeyboardWillHideNotification object:nil];
}
// 创建返回按钮
- (void)createBtn{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 23*kScreenWidthP, 30*kScreenWidthP, 30*kScreenWidthP)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginBackBtn:)];
    [backView addGestureRecognizer:backTap];
    _registBackImageView = [ControlsView createImageViewFrame:CGRectMake(18*kScreenWidthP, 10*kScreenWidthP, 8.9*kScreenWidthP, 17.8*kScreenWidthP) imageName:@"back"];
    [backView addSubview:_registBackImageView];
    
}
// 返回按钮实现功能
- (void)loginBackBtn:(UIButton *)btn{
    if ([_isFirstPage isEqualToString:@"FirstPageViewController"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)forgetKeyBoardWillShowWordVctrl:(NSNotification *)notification{
    
    //通过消息中的信息可以获取键盘的frame对象
    NSValue *keyboardObj = [[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 获取键盘的尺寸,也即是将NSValue转变为CGRect
    CGRect keyrect;
    [keyboardObj getValue:&keyrect];
    
    if (keyrect.size.height > kScreenHeight-_completeBtn.frame.size.height-_completeBtn.frame.origin.y) {
        CGAffineTransform translateForm = CGAffineTransformMakeTranslation(0 , kScreenHeight-_completeBtn.frame.size.height-_completeBtn.frame.origin.y-keyrect.size.height);
        self.view .transform = translateForm;
    }
}

- (void)forgetKeyBoardWillHideWordVctrl:(NSNotification *)notification{
    //通过消息中的信息可以获取键盘的frame对象
    NSValue *keyboardObj = [[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 获取键盘的尺寸,也即是将NSValue转变为CGRect
    CGRect keyrect;
    [keyboardObj getValue:&keyrect];
    if (keyrect.size.height > kScreenHeight-_completeBtn.frame.size.height-_completeBtn.frame.origin.y) {
        CGAffineTransform translateForm = CGAffineTransformMakeTranslation(0 , -1/2*kScreenHeight+1/2*_completeBtn.frame.size.height+1/2*_completeBtn.frame.origin.y+1/2*keyrect.size.height);
        self.view .transform = translateForm;
    }
}

- (void)forgetLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)createView{
    // 创建手机号TextField以及下面的线
    _phoneNumText = [ControlsView createTextFieldFrame:CGRectMake(38*kScreenWidthP, 64+70*kScreenWidthP, kScreenWidth-76*kScreenWidthP, 40*kScreenWidthP) borderStyle:UITextBorderStyleNone textAlignment:NSTextAlignmentLeft font:15 placeholder:nil clearButtonMode:UITextFieldViewModeWhileEditing leftViewMode:UITextFieldViewModeAlways clearsOnBeginEditing:YES secureTextEntry:NO leftViewTitle:@"手机号" textColor:RGBA(0, 0, 0, 1) backgroundColor:RGBA(255, 255, 255, 1) labelTextColor:UIColorFromRGB(666666) delegate:self];
    [self.view addSubview:_phoneNumText];
    
    _phoneNumLineLabel = [ControlsView createLabelFrame:CGRectMake(38*kScreenWidthP, 64+121*kScreenWidthP, kScreenWidth-76*kScreenWidthP, 0.5*kScreenWidthP) backgroundColor:RGBA(165, 165, 165, 1) title:nil font:0];
    [self.view addSubview:_phoneNumLineLabel];
    
    
    // 创建验证码TextField以及下面的线
    _getVerifiText = [ControlsView createTextFieldFrame:CGRectMake(38*kScreenWidthP, 64+133*kScreenWidthP, kScreenWidth-200*kScreenWidthP, 40*kScreenWidthP) borderStyle:UITextBorderStyleNone textAlignment:NSTextAlignmentLeft font:15 placeholder:nil clearButtonMode:UITextFieldViewModeWhileEditing leftViewMode:UITextFieldViewModeAlways clearsOnBeginEditing:YES secureTextEntry:NO leftViewTitle:@"验证码" textColor:RGBA(0, 0, 0, 1) backgroundColor:RGBA(255, 255, 255, 1) labelTextColor:UIColorFromRGB(666666) delegate:self];
    [self.view addSubview:_getVerifiText];
    
    // 验证码
    _registVerfiLable = [ControlsView createLabelFrame:CGRectMake(kScreenWidth-140*kScreenWidthP, 64+140*kScreenWidthP, 100*kScreenWidthP, 34*kScreenWidthP) backgroundColor:RGBA(255, 255, 255, 1) title:@"获取验证码" font:14*kScreenWidthP];
    _registVerfiLable.userInteractionEnabled = YES;
    _registVerfiLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13*kScreenWidthP];
    _registVerfiLable.textColor = RGBA(61, 192, 239, 1);
    _registVerfiLable.textAlignment = NSTextAlignmentCenter;
    _registVerfiLable.layer.cornerRadius = 15*kScreenWidthP;
    _registVerfiLable.layer.masksToBounds = YES;
    _registVerfiLable.layer.borderWidth = 1*kScreenWidthP;
    _registVerfiLable.layer.borderColor = RGBA(61, 192, 239, 1).CGColor;
    
    [self.view addSubview:_registVerfiLable];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getForgetVerifi:)];
    [_registVerfiLable addGestureRecognizer:tap];
    
    _getVerifiLabel = [ControlsView createLabelFrame:CGRectMake(38*kScreenWidthP, 64+184*kScreenWidthP, kScreenWidth-190*kScreenWidthP, 0.5*kScreenWidthP) backgroundColor:RGBA(165, 165, 165, 1) title:nil font:0];
    [self.view addSubview:_getVerifiLabel];
    
    
    // 创建密码的TextField以及下面的线
    _passWordText = [ControlsView createTextFieldFrame:CGRectMake(38*kScreenWidthP, 64+196*kScreenWidthP, kScreenWidth-76*kScreenWidthP, 40*kScreenWidthP) borderStyle:UITextBorderStyleNone textAlignment:NSTextAlignmentLeft font:15 placeholder:nil clearButtonMode:UITextFieldViewModeWhileEditing leftViewMode:UITextFieldViewModeAlways clearsOnBeginEditing:YES secureTextEntry:NO leftViewTitle:@"重置密码" textColor:RGBA(0, 0, 0, 1) backgroundColor:RGBA(255, 255, 255, 1) labelTextColor:UIColorFromRGB(666666) delegate:self];
    [self.view addSubview:_passWordText];
    
    _paaWordLabel = [ControlsView createLabelFrame:CGRectMake(38*kScreenWidthP, 64+247*kScreenWidthP, kScreenWidth-76*kScreenWidthP, 0.5*kScreenWidthP) backgroundColor:RGBA(165, 165, 165, 1) title:nil font:0];
    [self.view addSubview:_paaWordLabel];
    
    _completeBtn = [ControlsView createButtonFrame:CGRectMake(53*kScreenWidthP, 64+297*kScreenWidthP, kScreenWidth-106*kScreenWidthP, 45*kScreenWidthP) title:@"确定" titleColor:[UIColor blackColor] backgroundColor:RGBA(255, 255, 255, 1) target:self action:@selector(completeBtn:)];
    _completeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*kScreenWidthP];
    _completeBtn.layer.cornerRadius = 25*kScreenWidthP;
    _completeBtn.layer.masksToBounds = YES;
    _completeBtn.layer.borderWidth = 0.8;
    _completeBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_completeBtn];
    
}
- (void)getForgetVerifi:(id)sender{
    
}
- (void)completeBtn: (UIButton *)btn{
    
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
