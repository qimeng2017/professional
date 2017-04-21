//
//  LNActionSheetView.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/1/14.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
//按钮顺序index依次从上往下
typedef  void(^LSActionSheetBlock)(int index);


//按钮显示顺序 title 其他按钮 销毁按钮 取消按钮
@interface LNActionSheetView : UIView
+(void)showWithTitle:(NSString*)title  destructiveTitle:(NSString*)destructiveTitle  otherTitles:(NSArray*)otherTitles block:(LSActionSheetBlock)block;
@end
