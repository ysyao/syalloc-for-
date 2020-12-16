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
    [self setContentOffset:point animated:YES];
}

- (void)dealloc
{
//    [self.titleView removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedItemIndex))];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    
//    CGFloat offset = scrollView.contentOffset.x - self.oldPositionOffsetX;
//    CGFloat w = self.parentVc.view.frame.size.width;
//    if (offset >= w) {
//        self.titleView.selectedItemIndex += 1;
//        self.oldPositionOffsetX = scrollView.contentOffset.x;
//    }
//
//    else if (offset <= -w) {
//        self.titleView.selectedItemIndex -= 1;
//        self.oldPositionOffsetX = scrollView.contentOffset.x;
//    }
    
}

@end
