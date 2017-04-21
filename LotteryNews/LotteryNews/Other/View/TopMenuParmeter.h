//
//  TopMenuParmeter.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#ifndef TopMenuParmeter_h
#define TopMenuParmeter_h

//RGB Color
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//FullScreen
#define FUll_VIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define FUll_VIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define FUll_CONTENT_HEIGHT_WITHOUT_TAB ([[UIScreen mainScreen] bounds].size.height-64)
#define SELFWIDTH self.frame.size.width
#define SELFHEIGHT self.frame.size.height
#define NinaNavigationBarHeight 64

//NinaSelectionView Parameters
#define PerNum  3 //Better between 2~5
#define Nina_View_Width FUll_VIEW_WIDTH
#define Nina_View_X (FUll_VIEW_WIDTH - Nina_View_Width) / 2
#define Nina_Button_X 15
#define Nina_Button_Height 30
#define Nina_Button_Width (Nina_View_Width - 2 * Nina_Button_X - (PerNum - 1) * Nina_Button_Space) / PerNum
#define Nina_Button_TopSpace 17.5
#define Nina_Button_Space 10
#define Hold_Duration 0.2
#endif /* TopMenuParmeter_h */
