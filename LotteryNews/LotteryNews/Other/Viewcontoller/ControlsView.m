//
//  ControlsView.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "ControlsView.h"

@implementation ControlsView
+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadius clipsToBounds:(BOOL)clipsToBounds userInteractionEnabled:(BOOL)userInteractionEnabled{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    if (imageName) {
        [imageView setImage:[UIImage imageNamed:imageName]];
    }
    
    imageView.layer.cornerRadius = cornerRadius;
    // 可以被裁剪
    imageView.clipsToBounds = clipsToBounds;
    // 响应用户的交互
    imageView.userInteractionEnabled = userInteractionEnabled;
    return imageView;
}

+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName{
    
    return [self createImageViewFrame:frame imageName:imageName cornerRadius:0.f clipsToBounds:YES userInteractionEnabled:YES];
}

+ (UITextField *)createTextFieldFrame:(CGRect)frame borderStyle:(UITextBorderStyle)borderStyle textAlignment:(NSTextAlignment)textAlignment font:(CGFloat)font placeholder:(NSString *)placeholder clearButtonMode:(UITextFieldViewMode)clearButtonMode leftViewMode:(UITextFieldViewMode)leftViewMode  clearsOnBeginEditing:(BOOL)clearsOnBeginEditing secureTextEntry:(BOOL)secureTextEntry leftViewTitle:(NSString *)leftViewTitle textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor labelTextColor:(UIColor *)labelTextColor delegate:(id)delegate{
    
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    // 里面label的颜色
    UILabel *label = [self createLabelFrame:CGRectMake(0, 0, 60*kScreenWidthP, 21*kScreenWidthP) backgroundColor:backgroundColor title:leftViewTitle font:15];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = labelTextColor;
    textField.leftView = label;
    
    textField.textAlignment = textAlignment;
    // 左边view能否显示
    textField.leftViewMode=leftViewMode;
    // text文字大小
    textField.font = [UIFont systemFontOfSize:font];
    // textfield类型
    textField.borderStyle = borderStyle;
    // textfield上面的灰色文字
    textField.placeholder = placeholder;
    [textField setValue:RGBA(79, 79, 79, 1) forKeyPath:@"_placeholderLabel.textColor"];
    // 加粗用boldSystemFontOfSize
    [textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    // 编辑时方框右边出现叉叉
    textField.clearButtonMode = clearButtonMode;
    // 再次编辑是否清空
    textField.clearsOnBeginEditing = clearsOnBeginEditing;
    // 密码的形式
    textField.secureTextEntry = secureTextEntry;
    
    textField.textColor = textColor;
    textField.backgroundColor = backgroundColor;
    textField.delegate = delegate;
    return textField;
}

+ (UITextField *)createTextFieldFrame:(CGRect)frame borderStyle:(UITextBorderStyle)borderStyle font:(CGFloat)font  textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.font = [UIFont systemFontOfSize:font];
    textField.borderStyle = borderStyle;
    textField.textColor = textColor;
    textField.backgroundColor = backgroundColor;
    return textField;
    
}

+ (UIView *)createViewFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    return view;
}

+ (UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor numberOfLines:(NSInteger)numberOfLines  layerCornerRadius:(CGFloat)layerCornerRadius{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    label.numberOfLines = numberOfLines;
    label.layer.cornerRadius = layerCornerRadius;
    label.backgroundColor = backgroundColor;
    return label;
}

+ (UILabel *)createLabelFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor title:(NSString *)title font:(CGFloat)font {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = backgroundColor;
    label.text = title;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:font];
    
    return label;
    
}
+ (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title selectTitle:(NSString *)selectTitle  titleColor:(UIColor *)titleColor bgImageName:(NSString *)bgImageName selectImageName:(NSString *)selectImageName backgroundColor:(UIColor *)backgroundColor layerCornerRadius:(CGFloat)layerCornerRadius target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (selectTitle) {
        [btn setTitle:selectTitle forState:UIControlStateSelected];
    }
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    if (selectImageName) {
        [btn setImage:[[UIImage imageNamed:selectImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    }
    if (backgroundColor) {
        btn.backgroundColor = backgroundColor;
    }
    if (layerCornerRadius) {
        btn.layer.cornerRadius = layerCornerRadius;
    }
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return btn;
}

+ (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateSelected];
    btn.backgroundColor = backgroundColor;
    btn.titleLabel.backgroundColor = [UIColor whiteColor];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor  backgroundColor:(UIColor *)backgroundColor font:(CGFloat)font borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.tintColor = tintColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.layer.borderWidth = borderWidth;
    btn.layer.cornerRadius = cornerRadius;
    btn.layer.borderColor = (__bridge CGColorRef _Nullable)(borderColor);
    btn.backgroundColor = backgroundColor;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIScrollView *)createScrollViewFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor contentSize:(CGSize)contentSize{
    UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:frame];
    scroView.backgroundColor = backgroundColor;
    scroView.contentSize = contentSize;
    return scroView;
}

@end
