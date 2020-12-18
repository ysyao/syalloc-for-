//
//  WBOHomeScrollView.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/16.
//

#import "WBOHomeScrollView.h"
@interface WBOHomeScrollView()<UIScrollViewDelegate>

@property (nonatomic, weak)WBOHomeTitleView *titleView;

@property (nonatomic, weak)UIViewController *parentVc;

@property (nonatomic, assign) CGFloat oldPositionOffsetX;

@property (nonatomic, strong) NSMutableArray<UIViewController *> *childViewControllers;



@end

@implementation WBOHomeScrollView

- (instancetype)initWithHomeTitleView:(WBOHomeTitleView *)titleView parentViewController:(UIViewController *)parentViewController
{
    self = [super init];
    if (self) {
        self.titleView = titleView;
        self.parentVc = parentViewController;
        self.oldPositionOffsetX = 0.00f;
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
            CGRect frame = vc.view.frame;
            frame.origin.x = self.parentVc.view.frame.size.width * i;
            vc.view.frame = frame;
            [vc didMoveToParentViewController:self.parentVc];
            
            [self.childViewControllers addObject:vc];
            i++;
        }
    }
    
    // 设置titleview的监听器
//    [self.titleView addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedItemIndex)) options:NSKeyValueObservingOptionNew context:nil];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedItemIndex))]) {
//        // title view 正在被切换
//        WBOLog(@"changed %lu", (unsigned long)self.titleView.selectedItemIndex);
//
//    }
//}

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    // 滑动连带titleview的tab下方动画
    if (self.titleView.items.count > 1) {
        
        UIViewController *vc = self.childViewControllers[self.titleView.selectedItemIndex];
        
//        CGFloat offset = scrollView.contentOffset.x - self.parentVc.view.frame.size.width * self.titleView.selectedItemIndex;
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

                CGFloat w = 40 + tabOffset;
                make.width.mas_equalTo(w);

                CGFloat centerXOffset = w / 2;
                CGFloat xOffset = (centerXOffset - 20) * mutiplier;
                WBOLog(@"xOffset:%f", xOffset);
                make.centerX.mas_equalTo(container.mas_centerX).with.offset(xOffset);
            }];
            
            if (fabs(offset) > screenLength / 2) {
                [self.titleView setUpAnimateIndicatorGradientColorByMutiplier:mutiplier];
            } else {
                [self.titleView setUpAnimateIndicatorGradientColorByMutiplier:0];
            }
        } else {
            CGFloat originCenterOffset = container.frame.size.width / 2;
            CGFloat mostLength = (container.frame.size.width + 40);
            CGFloat tabOffset = (offset * mutiplier - screenLength) /  screenLength * tabMoveLength;
            [indicator mas_updateConstraints:^(MASConstraintMaker *make) {

                CGFloat w = mostLength - tabOffset;
                make.width.mas_equalTo(w);

                CGFloat margin = (container.frame.size.width - 40) / 2;
                CGFloat centerXOffset =  w / 2 - (margin + 40 - tabOffset);

                CGFloat xOffset = (centerXOffset + originCenterOffset) * mutiplier;
                
                WBOLog(@"xOffset:%f", xOffset);
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
