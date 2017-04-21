//
//  LoginViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "LoginViewController.h"
#import "ControlsView.h"
#import "ForgetPsswordVC.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "NSString+Extension.h"
#import "UIScrollView+UITouch.h"
#import "LNScodeCountBtn.h"
#import "LNLottoryConfig.h"
#import "UserStore.h"
#import "KBRoundedButton.h"
#import "ProgressHUD.h"
#import <AFNetworking.h>
#import "HRNetworkTools.h"
#import "ZDUnderlineTextField.h"
#import "LNButton.h"
typedef NS_ENUM(NSInteger, TYPEVIEW) {
    LN_LOGINVIEW,
    LN_RSGISTVIEW
};
@interface LoginViewController ()<UITextFieldDelegate,WXApiManagerDelegate,LNScodeCountBtnDelegate>
{
 //登录
    ZDUnderlineTextField     *_loginPhoneNumberText;
    ZDUnderlineTextField     *_loginVerifiText;
    KBRoundedButton *_loginBtn;
    LNScodeCountBtn *_loginVerfiBtn;
    UIView          *_loginBackgroundView;
    UIView          *_loginVerifiView;
 
    
    
    
}

@property (nonatomic)TYPEVIEW typeView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WXApiManager sharedManager].delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    // 去消息通知中心订阅一条消息（当键盘将要显示时UIKeyboardWillShowNotification）执行相应的方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //隐藏键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBasice];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self AFNetworkReachabilityStatus];
}
//适配
- (void)setBasice{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-KScalwh(0));
    }];
    self.scrollView.alwaysBounceVertical=YES;
    self.scrollView.scrollEnabled=YES;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.viewContent=[[UIView alloc]init];
    [self.scrollView addSubview:self.viewContent];
    [self.viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self createView:self.viewContent];
    if (self.viewContent.subviews.count>0){
        [self.viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.viewContent.subviews.lastObject).offset(KScalwh(0));
        }];
    }
    
}
- (void)createView:(UIView*)contentView

{
    _loginBackgroundView = [self loginView];
    [contentView addSubview:_loginBackgroundView];
}

#pragma mark -- 登录界面
- (UIView *)loginView{
   UIView *loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT)];
  
    // 创建手机号TextField以及下面的线
    UIColor *color = [UIColor blackColor];
    _loginPhoneNumberText = [[ZDUnderlineTextField alloc]initWithFrame:CGRectZero];
    _loginPhoneNumberText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _loginPhoneNumberText.attributedPlaceholder = [[NSAttributedString alloc]
                                               initWithString:@"手机号"
                                               attributes:@{NSForegroundColorAttributeName : color}];
    _loginPhoneNumberText.keyboardType = UIKeyboardTypeNumberPad;
    _loginPhoneNumberText.font = [UIFont systemFontOfSize:15*kScreenWidthP];
    // 编辑时方框右边出现叉叉
    _loginPhoneNumberText.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 再次编辑是否清空
    _loginPhoneNumberText.clearsOnBeginEditing = YES;
    _loginPhoneNumberText.delegate = self;
    _loginPhoneNumberText.returnKeyType = UIReturnKeyDone;
    [loginView addSubview:_loginPhoneNumberText];
    [_loginPhoneNumberText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(loginView.mas_left).with.offset(30);
        make.right.mas_equalTo(loginView.mas_right).with.offset(-30);
        make.top.mas_equalTo(loginView.mas_top).with.offset(188);
        make.height.mas_equalTo(45);
    }];
    
    
    
    _loginVerifiView = [[UIView alloc]initWithFrame:CGRectZero];
    [loginView addSubview:_loginVerifiView];
    _loginVerifiView.hidden = NO;
    [_loginVerifiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_loginPhoneNumberText.mas_bottom).with.offset(50);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45));
    }];
    //创建验证码TextField以及下面的线
    _loginVerifiText = [[ZDUnderlineTextField alloc]initWithFrame:CGRectZero];
    
    _loginVerifiText.attributedPlaceholder = [[NSAttributedString alloc]
                                                   initWithString:@"验证码"
                                                   attributes:@{NSForegroundColorAttributeName : color}];
    _loginVerifiText.keyboardType = UIKeyboardTypeNumberPad;
    _loginVerifiText.font = [UIFont systemFontOfSize:15*kScreenWidthP];
    // 编辑时方框右边出现叉叉
    _loginVerifiText.clearButtonMode = UITextFieldViewModeWhileEditing;
    // 再次编辑是否清空
    _loginVerifiText.clearsOnBeginEditing = YES;
    // 密码的形式
    _loginVerifiText.secureTextEntry = NO;
    _loginVerifiText.delegate = self;
    [_loginVerifiView addSubview:_loginVerifiText];
    
   
    
    // 验证码
    _loginVerfiBtn = [[LNScodeCountBtn alloc]init];
    _loginVerfiBtn.delegate = self;
    [_loginVerifiView addSubview:_loginVerfiBtn];
    
    
    [_loginVerifiText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_loginVerifiView.mas_left).with.offset(30);
        make.top.mas_equalTo(_loginVerifiView.mas_top);
        make.right.mas_equalTo(_loginVerfiBtn.mas_left).with.offset(10);
        make.height.mas_equalTo(45);
    }];
    [_loginVerfiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_loginVerifiText.mas_bottom);
        make.right.mas_equalTo(_loginVerifiView.mas_right).with.offset(-30);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    //密码
       // 创建登录按钮
    _loginBtn = [[KBRoundedButton alloc]initWithFrame:CGRectMake(53*kScreenWidthP, 435*kScreenWidthP, 270*kScreenWidthP, 45*kScreenWidthP)];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColorForStateNormal:RGBA(34, 34, 34, 1)];
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*kScreenWidthP];
    _loginBtn.layer.borderWidth = 1*kScreenWidthP;
    _loginBtn.layer.borderColor = RGBA(34, 34, 34, 1).CGColor;
    _loginBtn.layer.masksToBounds = YES;
    [loginView addSubview:_loginBtn];

    if ([WXApi isWXAppInstalled]){
        LNButton *weichatBtn = [LNButton buttonWithType:UIButtonTypeCustom];
        
        [weichatBtn setImage:[UIImage imageNamed:@"login-wechat.png"] forState:UIControlStateNormal];
        [weichatBtn setTitle:@"微信账号登入" forState:UIControlStateNormal];
        weichatBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*kScreenWidthP];
        weichatBtn.backgroundColor = [UIColor clearColor];
        weichatBtn.titleLabel.backgroundColor = [UIColor clearColor];
        [weichatBtn setTitleColor:RGBA(67, 181, 223, 1) forState:UIControlStateNormal];
        
        weichatBtn.imageRect = CGRectMake(10, 10, 18.5*1.2*kScreenWidthP, 15.6*1.2*kScreenWidthP);
        weichatBtn.titleRect = CGRectMake(35, 10, 120, 20);
        [weichatBtn addTarget:self action:@selector(weichatBtn) forControlEvents:UIControlEventTouchUpInside];
        [loginView addSubview:weichatBtn];
        weichatBtn.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 80, 250, 190, 40);
        [weichatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(loginView.mas_bottom).with.offset(-60*kScreenWidthP);
            make.centerX.mas_equalTo(loginView.mas_centerX);
            make.height.mas_equalTo(50);
        }];
    }
    return loginView;
}








/**
 点击下面的登入
 */
- (void)loginAction{
        [self review];
}

- (void)review{
    if (_loginPhoneNumberText.text.length <= 0 || _loginPhoneNumberText.text == nil) {
        [[ProgressHUD sharedInstance]showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if (_loginVerifiText.text.length <= 0 || _loginVerifiText.text == nil) {
        [[ProgressHUD sharedInstance] showInfoWithStatus:@"请输入正确的验证码"];
        return;
    }
    NSDictionary *dict = @{@"phone_number":_loginPhoneNumberText.text,@"scode":_loginVerifiText.text};
    _loginBtn.working = YES;
    [self keyResignFirstResponder];
    [self loginUser:dict login_type:@"1"];
    
    [_loginVerfiBtn closeTimer];
}
// 获取验证码
- (void)scodeCountBtnClicked{
    if (_loginPhoneNumberText.text.length <= 0 || _loginPhoneNumberText.text == nil) {
        [[ProgressHUD sharedInstance]showInfoWithStatus:@"请输入手机号"];
        return;
    }
    [_loginVerfiBtn initWithCountdownBeginNumber];
    _loginVerfiBtn.countdownBeginNumber = 60;
    [[UserStore sharedInstance]getScode:_loginPhoneNumberText.text sucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSString *message = [responseObject objectForKey:@"message"];
        if (codeNum) {
           NSInteger code = [codeNum integerValue];
            if (code == 1) {
                [[ProgressHUD sharedInstance]showErrorOrSucessWithStatus:NO message:message];
            }else{
                [[ProgressHUD sharedInstance]showErrorOrSucessWithStatus:YES message:message];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)weichatBtn{
    if ([WXApi isWXAppInstalled]) {
        
        [WXApiRequestHandler sendAuthRequestScope:kAuthScope State:kAuthState OpenID:kAuthOpenID InViewController:self];
    }
}
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response{
    if (response.code) {
        [[UserStore sharedInstance] getAccess_token:response.code sucess:^(NSDictionary *dict) {
            [self uploadUserInfo:dict];
        }];

    }else{
        NSLog(@"微信登录失败");
    }
}

#pragma mark -上传用户信息
- (void)uploadUserInfo:(NSDictionary *)userInfo{
 
    [self loginUser:userInfo login_type:@"0"];
}


- (void)loginUser:(NSDictionary *)loginUserInfo login_type:(NSString *)login_type{
    kWeakSelf(self)
    [[UserStore sharedInstance]loginUser:loginUserInfo login_type:login_type sucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *numberCode = [responseObject objectForKey:@"code"];
        NSString *message = [responseObject objectForKey:@"message"];
        NSInteger code = [numberCode integerValue];
        if (code == 1) {
            NSNumber *login_typeNum = [responseObject objectForKey:@"is_bind"];
            NSString *login_types = [NSString stringWithFormat:@"%@",login_typeNum];
            NSString *userid = [responseObject objectForKey:@"userid"];
            UserDefaultSetObjectForKey(userid, LOTTORY_AUTHORIZATION_UID);
            UserDefaultSetObjectForKey(login_types, @"is_bind");
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(userLoginSucess)]) {
                [weakself.delegate userLoginSucess];
            }
           
            
        }else{
            [[ProgressHUD sharedInstance]showErrorOrSucessWithStatus:YES message:message];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _loginBtn.working = NO;
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
 
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"收回键盘");
    [self keyResignFirstResponder];
    
}

//去注册
- (void)toRegistBtn{
    _loginBackgroundView.hidden = YES;
    //_registBackgroundView.hidden = NO;
}
- (void)keyResignFirstResponder{
    [_loginPhoneNumberText resignFirstResponder];
    [_loginVerifiText resignFirstResponder];
}
#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//当键盘将要显示时，将底部的view向上移到键盘的上面
-(void)keyboardWillShow:(NSNotification*)notification{
    //通过消息中的信息可以获取键盘的frame对象
    NSValue *keyboardObj = [[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 获取键盘的尺寸,也即是将NSValue转变为CGRect
    CGRect keyrect;
    [keyboardObj getValue:&keyrect];
    CGRect rect=self.view.frame;
  
        //如果键盘的高度大于底部控件到底部的高度，将_scrollView往上移 也即是：-（键盘的高度-底部的空隙）
    if (!IS_IPHONE_4_or_5) {
        if (CGRectGetMaxY(_loginBtn.frame) > keyrect.origin.y) {
            rect.origin.y=-(CGRectGetMaxY(_loginBtn.frame) - keyrect.origin.y);
            self.view.frame = rect;
        }
    }
    
}

//当键盘将要隐藏时（将原来移到键盘上面的视图还原）
-(void)keyboardWillHide:(NSNotification *)notification{
    CGRect rect=self.view.frame;
    NSValue *keyboardObj = [[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 获取键盘的尺寸,也即是将NSValue转变为CGRect
    CGRect keyrect;
    [keyboardObj getValue:&keyrect];
    rect.origin.y= 0;
    self.view.frame = rect;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
