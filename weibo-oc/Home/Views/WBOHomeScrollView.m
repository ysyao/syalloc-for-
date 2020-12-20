//
//  WBOHomeScrollView.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/16.
//

#import "WBOHomeScrollView.h"
@interface WBOHomeScrollView()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak)WBOHomeTitleView *titleView;

@property (nonatomic, weak)UIViewController *parentVc;

@property (nonatomic, strong) NSMutableArray<UIViewController *> *childViewControllers;



@end

@implementation WBOHomeScrollView

- (instancetype)initWithHomeTitleView:(WBOHomeTitleView *)titleView parentViewController:(UIViewController *)parentViewController
{
    self = [super init];
    if (self) {
        self.titleView = titleView;
        self.parentVc = parentViewController;

        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    if (!self.titleView || !self.parentVc) {
        return;
    }
    
    if (!self.titleView.items || self.titleView.items == 0) {
        return;
    }
    
    /// 添加uiscrollview到parent view controller，并且设置其参数
    [self.parentVc.view addSubview:self];
    self.frame = self.parentVc.view.frame;
    [self setBouncesZoom:NO];
    [self setBounces:NO];
    
    [self setShowsVerticalScrollIndicator:NO];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setContentSize:CGSizeMake(self.parentVc.view.frame.size.width * self.titleView.items.count, self.parentVc.view.frame.size.height)];
    [self setPagingEnabled:YES];
//    [self setScrollEnabled:NO];
    
    /// What's the UIScrollView contentInset property for?
    /// https://stackoverflow.com/questions/1983463/whats-the-uiscrollview-contentinset-property-for
    
    /// contentinset的概念，width，height，
    //   _|←_cW_→_|_↓_
    //    |       |
    // ---------------
    //    |content| ↑
    //  ↑ |content| contentInset.top
    // cH |content|
    //  ↓ |content| contentInset.bottom
    //    |content| ↓
    // ---------------
    //    |content|
    // -------------↑-
    
    
    /// https://stackoverflow.com/questions/5095713/disabling-vertical-scrolling-in-uiscrollview
    /// Disabling vertical scrolling in UIScrollView
    /// iOS11之前用这个 self.automaticallyAdjustsScrollViewInsets = NO;
    /// The default value of this property is true, which lets container view controllers know that they should adjust the scroll view insets of this view controller’s view to account for screen areas consumed by a status bar, search bar, navigation bar, toolbar, or tab bar. Set this property to false if your view controller implementation manages its own scroll view inset adjustments.
    ///
    ///
    /// iOS11之后用contentInsetAdjustmentBehavior来代替automaticallyAdjustsScrollViewInsets：
    ///    case automatic
    ///    Automatically adjust the scroll view insets.
    ///    case scrollableAxes
    ///    Adjust the insets only in the scrollable directions.
    ///    case never
    ///    Do not adjust the scroll view insets.
    ///    case always
    ///    Always include the safe area insets in the content adjustment.
    
    self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    self.delegate = self;
    
    
    /// 添加ui scroll view的子页面
    int i = 0;
    for (WBOTitleItem *item in self.titleView.items) {

        
        // 根据传递的viewcontroller class新建页面
        if (item.viewControllerClass) {
            /// 增加scrollview中的子viewcontrollers
            /// https://stackoverflow.com/questions/19820939/setting-up-uiscrollview-to-swipe-between-3-view-controllers
            /// Setting up UIScrollView to swipe between 3 view controllers
            
            UIViewController *vc = [[item.viewControllerClass alloc] init];
            [self.parentVc addChildViewController:vc];
            [self addSubview:vc.view];
            
            CGRect frame = self.parentVc.view.frame;
            frame.origin.x = self.parentVc.view.frame.size.width * i;
            vc.view.frame = frame;
            [vc didMoveToParentViewController:self.parentVc];
            
            [self.childViewControllers addObject:vc];
            
            i++;
        }
        
    }
}

- (void)addGestureRecognizers {
    [self setScrollEnabled:NO];
    UISwipeGestureRecognizer *swipeVerticalization = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeVerticalizationSel:)];
    
//    swipeVerticalization.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    
    [self addGestureRecognizer:swipeVerticalization];
    
}

- (void)swipeVerticalizationSel:(UISwipeGestureRecognizer *)gestureRecoginzer {
    switch (gestureRecoginzer.direction) {
        case UISwipeGestureRecognizerDirectionDown:
            WBOLog(@"down");
            break;
        case UISwipeGestureRecognizerDirectionUp:
            WBOLog(@"up");
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            WBOLog(@"left");
            break;
        case UISwipeGestureRecognizerDirectionRight:
            WBOLog(@"right");
            break;
        default:
            break;
    }
}


- (void)moveScrollViewPage {
    CGPoint point = CGPointMake(self.titleView.selectedItemIndex * self.parentVc.view.frame.size.width, self.contentOffset.y);
    [self setContentOffset:point animated:NO];
}

#pragma mark - getters
- (NSMutableArray<UIViewController *> *)childViewControllers {
    if (!_childViewControllers) {
        _childViewControllers = [[NSMutableArray alloc] init];
    }
    return _childViewControllers;
}

#pragma mark - delegator

/// 如果有上下滑动的动作，交给子uiview来处理
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    // 如果控件不允许与用户交互那么返回 nil
//    if (self.userInteractionEnabled == NO || self.alpha <= 0.01 || self.hidden == YES) {
//        return nil;
//    }
//    // 如果这个点不在当前控件中那么返回 nil
//    if (![self pointInside:point withEvent:event]) {
//        return nil;
//    }
//
//    for (UIView *view in self.subviews) {
//        // 把当前触摸点坐标转换为相对于子控件的触摸点坐标
//        CGPoint subPoint = [self convertPoint:point toView:view];
//        // 判断是否在子控件中找到了更合适的子控件
//        UIView *nextVw = [view hitTest:subPoint withEvent:event];
//        // 如果找到了返回
//        if (nextVw) {
//            return nextVw;
//        }
//    }
//
//    return self;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    // 滑动连带titleview的tab下方动画
    if (self.titleView.items.count > 1) {
        
        UIViewController *vc = self.childViewControllers[self.titleView.selectedItemIndex];
        CGFloat offset = scrollView.contentOffset.x - vc.view.frame.origin.x;
        CGFloat screenLength = self.parentVc.view.frame.size.width / 2;
        
        UIView *container = self.titleView.indicatorStack.arrangedSubviews[self.titleView.selectedItemIndex];
        UIView *indicator = self.titleView.animateIndicator;

        CGFloat tabMoveLength = container.frame.size.width;


        /// 动画：向右滑动动画mutiplier=1，向左滑动mutiplier=-1
        CGFloat mutiplier = 0;
        if (offset < 0) {
            mutiplier = -1;
        } else if(offset > 0) {
            mutiplier = 1;
        }
        
//        WBOLog(@"leftright: %f", offset);
        if (fabs(offset) <= screenLength) {
            
            CGFloat tabOffset = offset * mutiplier / screenLength * tabMoveLength;
            [indicator mas_updateConstraints:^(MASConstraintMaker *make) {

                CGFloat w = WBOHomeTitleView.animatedIndicatorWidth + tabOffset;
                make.width.mas_equalTo(w);

                CGFloat centerXOffset = w / 2;
                CGFloat xOffset = (centerXOffset - WBOHomeTitleView.animatedIndicatorWidth / 2) * mutiplier;
//                WBOLog(@"xOffset:%f", xOffset);
                make.centerX.mas_equalTo(container.mas_centerX).with.offset(xOffset);
            }];
            
            if (fabs(offset) > screenLength / 2) {
                [self.titleView setUpAnimateIndicatorGradientColorByMutiplier:mutiplier];
            } else {
                [self.titleView setUpAnimateIndicatorGradientColorByMutiplier:0];
            }
        } else {
            CGFloat originCenterOffset = container.frame.size.width / 2;
            CGFloat mostLength = (container.frame.size.width + WBOHomeTitleView.animatedIndicatorWidth);
            CGFloat tabOffset = (offset * mutiplier - screenLength) /  screenLength * tabMoveLength;
            [indicator mas_updateConstraints:^(MASConstraintMaker *make) {

                CGFloat w = mostLength - tabOffset;
                make.width.mas_equalTo(w);

                CGFloat margin = (container.frame.size.width - WBOHomeTitleView.animatedIndicatorWidth) / 2;
                CGFloat centerXOffset =  w / 2 - (margin + WBOHomeTitleView.animatedIndicatorWidth - tabOffset);

                CGFloat xOffset = (centerXOffset + originCenterOffset) * mutiplier;
                
//                WBOLog(@"xOffset:%f", xOffset);
                make.centerX.mas_equalTo(container.mas_centerX).with.offset(xOffset);
            }];
            
            
            if (fabs(offset) > screenLength / 2) {
                [self.titleView setUpAnimateIndicatorGradientColorByMutiplier:mutiplier];
            } else {
                [self.titleView setUpAnimateIndicatorGradientColorByMutiplier:0];
            }
        }
        
    }
    
    
    // 滑动连带titleview的tab变动
    if (self.childViewControllers && self.childViewControllers.count > 0) {
        for (UIViewController *vc in self.childViewControllers) {
            if (scrollView.contentOffset.x == vc.view.frame.origin.x) {
                self.titleView.selectedItemIndex = [self.childViewControllers indexOfObject:vc];
            }
        }
    }
   
    
}



@end
