//
//  ControlsView.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlsView : NSObject
+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName  cornerRadius:(CGFloat)cornerRadius clipsToBounds:(BOOL)clipsToBounds userInteractionEnabled:(BOOL)userInteractionEnabled;
+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName;

+ (UITextField *)createTextFieldFrame:(CGRect)frame borderStyle:(UITextBorderStyle)borderStyle textAlignment:(NSTextAlignment)textAlignment font:(CGFloat)font placeholder:(NSString *)placeholder clearButtonMode:(UITextFieldViewMode)clearButtonMode leftViewMode:(UITextFieldViewMode)leftViewMode  clearsOnBeginEditing:(BOOL)clearsOnBeginEditing secureTextEntry:(BOOL)secureTextEntry leftViewTitle:(NSString *)leftViewTitle textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor labelTextColor:(UIColor *)labelTextColor delegate:(id)delegate;
+ (UITextField *)createTextFieldFrame:(CGRect)frame borderStyle:(UITextBorderStyle)borderStyle font:(CGFloat)font  textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor;

+ (UIView *)createViewFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;

+ (UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor numberOfLines:(NSInteger)numberOfLines layerCornerRadius:(CGFloat)layerCornerRadius;
+ (UILabel *)createLabelFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor title:(NSString *)title font:(CGFloat)font;

+ (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title  selectTitle:(NSString *)selectTitle titleColor:(UIColor *)titleColor bgImageName:(NSString *)bgImageName selectImageName:(NSString *)selectImageName backgroundColor:(UIColor *)backgroundColor layerCornerRadius:(CGFloat)layerCornerRadius target:(id)target action:(SEL)action;

+ (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action;

+ (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor  backgroundColor:(UIColor *)backgroundColor font:(CGFloat)font borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor target:(id)target action:(SEL)action;

+ (UIScrollView *)createScrollViewFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor  contentSize:(CGSize)contentSize;
@end
