//
//  CoverViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/3/6.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "CoverViewController.h"
#import "UserStore.h"
#import <AFNetworking.h>
@interface CoverViewController ()
@property(nonatomic,copy)showFinishBlock showFinishBlock;
@property(nonatomic,strong)UIImageView *launchImgView;
@property (nonatomic, strong)NSOperationQueue *parseQueue;
@end

@implementation CoverViewController
+(void)showWithAdFrame:(CGRect)frame  showFinish:(showFinishBlock)showFinish
{
    CoverViewController *AdVC = [[CoverViewController alloc] initWithFrame:frame showFinish:showFinish];
    [UIApplication sharedApplication].keyWindow.rootViewController = AdVC;
   
}
- (instancetype)initWithFrame:(CGRect)frame showFinish:(showFinishBlock)showFinish
{
    self = [super init];
    if (self) {
       
        _showFinishBlock = [showFinish copy];
        [self.view addSubview:self.launchImgView];
    
    }
    return self;
}
-(UIImageView *)launchImgView
{
    if(_launchImgView==nil)
    {
        _launchImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _launchImgView.image = [self getLaunchImage];
    }
    return _launchImgView;
}
-(UIImage *)getLaunchImage
{
    UIImage *imageP = [self launchImageWithType:@"Portrait"];
    if(imageP) return imageP;
    UIImage *imageL = [self launchImageWithType:@"Landscape"];
    if(imageL) return imageL;
    NSLog(@"获取LaunchImage失败!请检查是否添加启动图,或者规格是否有误.");
    return nil;
}
-(UIImage *)launchImageWithType:(NSString *)type
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = type;
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"])
            {
                imageSize = CGSizeMake(imageSize.height, imageSize.width);
            }
            if(CGSizeEqualToSize(imageSize, viewSize))
            {
                launchImageName = dict[@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:launchImageName];
                return image;
            }
        }
    }
    return nil;
}
- (NSOperationQueue *)parseQueue{
    if (_parseQueue==nil) {
        _parseQueue = [[NSOperationQueue alloc]init];
       
        [_parseQueue setMaxConcurrentOperationCount:1];
       
    }
    return _parseQueue;
}
- (void)network{
   
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
   
    dispatch_group_async(group, queue, ^{
         [self requestCategories];
    });
   
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"updateUi");
         [self remove];
    });
    
    
   
}

-(void)remove{
    if(_showFinishBlock)  _showFinishBlock();
//    [UIView transitionWithView:[[UIApplication sharedApplication].delegate window] duration:0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        BOOL oldState=[UIView areAnimationsEnabled];
//        [UIView setAnimationsEnabled:NO];
//    
//        if(_showFinishBlock)  _showFinishBlock();
//        [UIView setAnimationsEnabled:oldState];
//    }completion:NULL];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self network];
    // Do any additional setup after loading the view.
}
#pragma mark -网络状态监测
- (void)AFNetworkReachabilityStatus{
    __weak CoverViewController *weakSelf = self;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self network];
                
               
                NSLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self network];
               
                NSLog(@"wifi的网络");
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
    
}
- (void)requestCategories{
    
   [[UserStore sharedInstance]getCategoriesAndPlayTypeDefult];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
