//
//  PHPView.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "PHPView.h"
#import "LiuXSegmentView.h"
#import "LNLotteryCategories.h"
#import <TYAttributedLabel/TYAttributedLabel.h>
#import "PopoverView.h"
#import "UserStore.h"
#import "LNButton.h"
@interface PHPView ()

//@property (nonatomic, strong)UILabel *introductionLable;
@property (nonatomic, strong)UIImageView *avaterImageview;
@property (nonatomic, strong)TYAttributedLabel *nickNameL;
@property (nonatomic, strong)LiuXSegmentView *segement;
@property (nonatomic, strong)LNButton *categorySelectBtn;
@property (nonatomic, strong)LottoryCategoryModel *selectedCategoryModel;
@property (nonatomic, strong)LottoryPlaytypemodel *selectedPlayModel;
@property (nonatomic, strong)UIView *bottomView;

@end
@implementation PHPView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self customInit];
       
    }
    return self;
}
- (void)customInit{
    CGFloat marigin = 10;
   
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(marigin, 0, kScreenWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    
    UIImageView *avaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    avaImageView.backgroundColor = [UIColor redColor];
    avaImageView.layer.masksToBounds = YES;
    avaImageView.layer.cornerRadius = 15;
    [topView addSubview:avaImageView];
    
    _avaterImageview = avaImageView;
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(avaImageView.frame)+5, marigin, kScreenWidth, 20)];
    
    [topView addSubview:label];
    // 文字间隙
    label.characterSpacing = 2;
    // 文本行间隙
    label.linesSpacing = 6;
    label.textColor = [UIColor redColor];
    NSString *text = @" ";
    [label appendText:text];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedString addAttributeTextColor:[UIColor blueColor]];
    [attributedString addAttributeFont:[UIFont systemFontOfSize:15]];
    [label appendTextAttributedString:attributedString];

    [label sizeToFit];
    
    _nickNameL = label;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+1, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.7;
    [self addSubview:line1];
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), kScreenWidth, 50)];
    centerView.backgroundColor = [UIColor whiteColor];
    //[self addSubview:centerView];
    UILabel *introductionL = [[UILabel alloc]init];
    introductionL.font = [UIFont systemFontOfSize:14];
    introductionL.textColor = [UIColor grayColor];
    introductionL.numberOfLines = 0;
    //[centerView addSubview:introductionL];
    //_introductionLable = introductionL;
    
    
//    [_introductionLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(centerView.mas_left).offset(marigin);
//        make.top.equalTo(centerView.mas_top).offset(5);
//    }];
    UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame)+5, kScreenWidth, 44)];
    [self addSubview:bView];
    _bottomView = bView;
   _categorySelectBtn = [LNButton buttonWithType:UIButtonTypeCustom];
    [_categorySelectBtn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    LottoryCategoryModel *model = [LNLotteryCategories sharedInstance].currentLottoryModel;
    _selectedCategoryModel = model;
    //初始进入数据
    [self getPlayData:model];
    [_categorySelectBtn setImage:[UIImage imageNamed:@"grrow_down"] forState:UIControlStateNormal];
    [_categorySelectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _categorySelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _categorySelectBtn.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [_categorySelectBtn setTitle:model.caipiao_name forState:UIControlStateNormal];
    _categorySelectBtn.imageRect = CGRectMake(10, 17, 10, 10);
    _categorySelectBtn.titleRect = CGRectMake(25, 11, 60, 20);
    [bView addSubview:_categorySelectBtn];
     _categorySelectBtn.frame = CGRectMake(0, 0, 80, 44);
}
//下拉选择
- (void)selected:(UIButton *)selected{
    NSArray *categoryArr = [LNLotteryCategories sharedInstance].categoryArray;
    NSMutableArray *actions = [NSMutableArray array];
    if (actions.count > 0) {
        [actions removeAllObjects];
    }
    for (LottoryCategoryModel *model in categoryArr) {
        PopoverAction *addFriAction = [PopoverAction actionWithImage:nil title:model.caipiao_name lottoryModel:model handler:^(PopoverAction *action) {
            [_categorySelectBtn setTitle:model.caipiao_name forState:UIControlStateNormal];
            _selectedCategoryModel = model;
            [self getPlayData:model];
        }];
        [actions addObject:addFriAction];
        
    }
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.hideAfterTouchOutside = YES;
    [popoverView showToView:selected withActions:actions];
}

- (void)getPlayData:(LottoryCategoryModel*)categoryModel{
    NSMutableArray *dataArray = [NSMutableArray array];
    [[UserStore sharedInstance]requestPlayType:categoryModel sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        if (code == 1) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            
            for (NSDictionary *dict in arr) {
                LottoryPlaytypemodel *PlayModel = [[LottoryPlaytypemodel alloc]initWithDictionary:dict error:nil];
                [dataArray addObject:PlayModel];
            }
            [self segmentView:dataArray];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//滚动
- (void)segmentView:(NSArray *)arr{
    if (_segement) {
        [_segement removeFromSuperview];
    }
    _segement = [[LiuXSegmentView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_categorySelectBtn.frame), 0, kScreenWidth-CGRectGetWidth(_categorySelectBtn.frame), 44) segmentType:@"play" titles:arr clickBlick:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
        LottoryPlaytypemodel *playModel = [arr objectAtIndex:index];
        if (_delegate&&[_delegate respondsToSelector:@selector(getPersonalData:play:)]) {
            [_delegate getPersonalData:_selectedCategoryModel play:playModel];
        }
    }];
   
    [_bottomView addSubview:_segement];
}
//专家信息数据
- (void)getHomePage{
    [[UserStore sharedInstance]getHomePage:_expert_id sucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        if (code == 1) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            NSString *nickName = [dataDic objectForKey:@"nickname"];
            NSString *introduceStr = [dataDic objectForKey:@"introduce"];
            NSString *imageStr = [dataDic objectForKey:@"images_url"];
            if ([imageStr isEqual:[NSNull null]]) {
                imageStr = nil;
            }
            NSString *introduce;
            
            if ([introduceStr isEqual:[NSNull null]]||introduceStr == nil) {
                introduce = @"该专家很懒还没有介绍";
                
            }else{
               introduce = introduceStr; 
            }
            [self setNickName:nickName introduction:introduce imageUrl:imageStr];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)setExpert_id:(NSString *)expert_id{
    _expert_id = expert_id;
    [self getHomePage];
}
- (void)setNickName:(NSString *)nickName introduction:(NSString *)introduction imageUrl:(NSString *)imageurl{
    _nickName = [NSString stringWithFormat:@"昵称:%@（专家）",nickName];
    _introducetion = [NSString stringWithFormat:@"简介：%@",introduction];
    [self setNeedsLayout];
    _nickNameL.text = _nickName;
    TYTextStorage *textStorage = [[TYTextStorage alloc]init];
    textStorage.range = [_nickName rangeOfString:@"昵称:"];
    textStorage.textColor = RGBA(0, 155, 0, 1);
    textStorage.font = [UIFont systemFontOfSize:14];
    [_nickNameL addTextStorage:textStorage];
    
    TYTextStorage *textStorage1 = [[TYTextStorage alloc]init];
    textStorage1.range = [_nickName rangeOfString:@"（专家）"];
    textStorage1.textColor = RGBA(0, 155, 0, 1);
    textStorage1.font = [UIFont systemFontOfSize:14];
    [_nickNameL addTextStorage:textStorage1];
    [_nickNameL sizeToFit];
    [self.avaterImageview sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"Icon-Small"] options:SDWebImageProgressiveDownload];
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    _introductionLable.text = _introducetion;
//    [_introductionLable sizeToFit];
   
}
@end
