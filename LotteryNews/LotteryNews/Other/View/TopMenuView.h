//
//  TopMenuView.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/20.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, NinaPopDirection) {
    /**<  Pop from above   **/
    NinaPopFromAboveToTop = 0,
    NinaPopFromAboveToMiddle = 1,
    NinaPopFromAboveToBottom = 2,
    /**<  Pop from below   **/
    NinaPopFromBelowToTop = 3,
    NinaPopFromBelowToMiddle = 4,
    NinaPopFromBelowToBottom = 5,
    /**<  Pop from left   **/
    NinaPopFromLeftToTop = 6,
    NinaPopFromLeftToMiddle = 7,
    NinaPopFromLeftToBottom = 8,
    /**<  Pop from right   **/
    NinaPopFromRightToTop = 9,
    NinaPopFromRightToMiddle = 10,
    NinaPopFromRightToBottom = 11,
};


@protocol TopMenuViewDelegate <NSObject>

@optional
/**
 *  @param button Select Button.
 */
- (void)selectNinaAction:(UIButton *)button;

@end
@interface TopMenuView : UIScrollView
- (instancetype)initWithTitles:(NSArray *)titles PopDirection:(NinaPopDirection)direction;
/**
 *  Show or dismiss NinaSelectionView when you needed.(No spring effect)
 */
- (void)showOrDismissNinaViewWithDuration:(NSTimeInterval)duration;
/**
 *  @param velocity     init pop speed level
 */
- (void)showOrDismissNinaViewWithDuration:(NSTimeInterval)duration usingNinaSpringWithDamping:(CGFloat)dampingRatio initialNinaSpringVelocity:(CGFloat)velocity;

/**
 *  Default Selected button tag number.(Range from 1~...)
 */
@property (nonatomic, assign) NSInteger defaultSelected;
/**
 *  Show shadowEffect or not.Default shadowAlpha is 0.5.
 */
@property (nonatomic, assign) BOOL shadowEffect;
/**
 *  If turn on shadowEffect,you can set alpha for shadowView.
 */
@property (nonatomic, assign) CGFloat shadowAlpha;
/**
 *  Set NinaSelection Pop Y.
 */
@property (nonatomic, assign) CGFloat nina_popY;
/**
 *  TopMenuViewDelegate
 */
@property (nonatomic, weak)id<TopMenuViewDelegate>ninaSelectionDelegate;
@end
