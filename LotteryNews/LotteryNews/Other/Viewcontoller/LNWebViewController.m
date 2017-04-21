//
//  LNWebViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "LNWebViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "LNActionSheetView.h"
#import "ProgressHUD.h"
@interface LNWebViewController () <UIWebViewDelegate>

{
    UIWebView *_webView;
    
    //UIActivityIndicatorView     *_indicatorView;
    
}

@property (nonatomic, strong) NSURL *aUrl;

@end

@implementation LNWebViewController
@synthesize aUrl;
- (instancetype)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        self.aUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD showWithStatus:@"Loading..."];
    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        [self.view addSubview:webView];
        _webView = webView;
        _webView.dataDetectorTypes = UIDataDetectorTypeLink;
        //UIActivityIndicatorView
//        {
//            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            _indicatorView.frame = CGRectMake((CGRectGetWidth(self.view.frame) - CGRectGetWidth(_indicatorView.frame)) / 2, (CGRectGetHeight(self.view.frame) - CGRectGetHeight(_indicatorView.frame)) / 2, CGRectGetWidth(_indicatorView.frame), CGRectGetHeight(_indicatorView.frame));
//            [self.view addSubview:_indicatorView];
//            
//        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.aUrl];
        
        [_webView loadRequest:request];
    }
    
}

- (void)back
{
    _webView.delegate = nil;
    [_webView stopLoading];
    
    if (self.presentingViewController.presentedViewController == self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)goBack
{
    [_webView stopLoading];
    [_webView goBack];
}

#pragma mark - UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[_indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
   // [_indicatorView stopAnimating];
    //添加图片可点击js
    [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];

    
   
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        for (NSInteger index = 0; index < self.imageArr.count; index++) {
//            NSString *url = self.imageArr[index];
//            if ([url isEqualToString:path]) {
//                [self selectedIndex:index];
//            }
//        }
        [self sheet:path];
        return NO;
    }
    return YES;
}
- (void)sheet:(NSString *)path{
  
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    UIImage *image = [UIImage imageWithData:imageData];
    [LNActionSheetView showWithTitle:nil destructiveTitle:nil otherTitles:@[@"保存图片"] block:^(int index) {
        if (index == 0) {
            if ([self isPhotoLibraryAvailable]) {
               UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
            
        }
    }];
}
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [[ProgressHUD sharedInstance]showErrorOrSucessWithStatus:NO message:@"保存成功"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    //[_indicatorView stopAnimating];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
