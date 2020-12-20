//
//  WBOHomeTitleView.h
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "WBOTitleItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBOHomeTitleView : UIView

@property (nonatomic, assign) NSUInteger selectedItemIndex;

@property (nonatomic, strong) NSArray<WBOTitleItem *> *items;

@property (nonatomic, strong) UIView *animateIndicator;


@property (nonatomic, strong) UIStackView *indicatorStack;

/// 将带有动画的indicator设置到某个indicatorstack下去并制定颜色
- (void)performAnimateIndicator;

- (void)setUpAnimateIndicatorGradientColorByMutiplier:(int)mutiplier;

+ (CGFloat)animatedIndicatorWidth;

+ (CGFloat)animatedIndicatorHeight;

@end



NS_ASSUME_NONNULL_END
