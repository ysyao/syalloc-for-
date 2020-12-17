//
//  WBOHomeViewController.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/12.
//

#import "WBOHomeViewController.h"
#import "WBOAuthorizationViewController.h"
#import "WBONetKitTimeline.h"
#import "WBOTimeline.h"
#import "WBOHomeTitleView.h"
#import "WBOTitleItem.h"
#import "WBOFollowingViewController.h"
#import "WBORecommendViewController.h"
#import "WBOHomeScrollView.h"

@interface WBOHomeViewController ()


@property (nonatomic, strong) WBONetKitTimeline *netKit;

@property (nonatomic, strong) WBOHomeTitleView *homeTitleView;

@property (nonatomic, strong) WBOHomeScrollView *scrollView;

@end

@implementation WBOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationbar];
    
}

#pragma mark - set up views

- (void)setUpNavigationbar {
    ///https://developer.apple.com/documentation/uikit/uinavigationcontroller/customizing_your_app_s_navigation_bar
    /// Customizing Your App’s Navigation Bar
    
    UIBarButtonItem *leftPhotoItem = [self newUIBarButtonItemWithTarget:self ImageName:@"photo" action:@selector(didPressPhotobutton:)];
    
    UIBarButtonItem *rightRedPacketItem = [self newUIBarButtonItemWithTarget:self ImageName:@"redpacket" action:@selector(didPressRedPacketButton:)];
    
    UIBarButtonItem *rightMoreItem = [self newUIBarButtonItemWithTarget:self ImageName:@"more" action:@selector(didPressMoreButton:)];
    
    UIBarButtonItem *fixed1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *fixed2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    [leftPhotoItem setTintColor:UIColor.blackColor];
    [rightRedPacketItem setTintColor:UIColor.redColor];
    [rightMoreItem setTintColor:[UIColor orangeColor]];
    
    self.navigationItem.leftBarButtonItems = @[leftPhotoItem, fixed1];
    self.navigationItem.rightBarButtonItems = @[rightMoreItem, rightRedPacketItem, fixed2];
    
    self.navigationItem.titleView = self.homeTitleView;
    
    /// https://stackoverflow.com/questions/46867592/swift-uitapgesture-on-view-in-a-titleview-not-working
    /// Swift UITapGesture on view in a titleView not working
    /// answer:Beginning with iOS 11, views added to toolbars as UIBarButtonItem using UIBarButtonItem(customView:) are now laid out using auto layout. This includes title views added to a UINavigationBar through the navigationItem.titleView property of a UIViewController. You should add sizing constraints on your titleView. For example:
    /// titleView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    /// titleView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    
    /// Otherwise, auto layout will use the intrinsic content size of your title view which is CGSize.zero. Gestures are masked to the bounds of the view they are attached to even if the sub views of that view are not. Because the bounds of titleView without constraints is CGRect.zero it will never fire. Add constraints and it works as expected.
    
    /// For more information see the WWDC 2017 session Updating your app for iOS 11.
    /// 总结：当titleView没有通过autolayout设置大小的时候，autolayout会用intrinsic content size（view最小size），这里默认为CGRectZero，因此不可能有点击事件触发。
    [self.homeTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    weakSelf();
    WBOTitleItem *item1 = [[WBOTitleItem alloc] initWithTitle:@"关注" indicatorColor:UIColor.orangeColor viewControllerClass:WBOFollowingViewController.class block:^(NSString * _Nonnull title, NSUInteger index) {
        WBOLog(@"guanzu");
        [weakSelf.scrollView moveScrollViewPage];
    }];
    WBOTitleItem *item2 = [[WBOTitleItem alloc] initWithTitle:@"推荐" indicatorColor:UIColor.redColor viewControllerClass:WBORecommendViewController.class block:^(NSString * _Nonnull title, NSUInteger index) {
        WBOLog(@"tuijian");
        [weakSelf.scrollView moveScrollViewPage];
    }];
    WBOTitleItem *item3 = [[WBOTitleItem alloc] initWithTitle:@"视频" indicatorColor:UIColor.redColor viewControllerClass:WBOFollowingViewController.class block:^(NSString * _Nonnull title, NSUInteger index) {
        WBOLog(@"tuijian");
        [weakSelf.scrollView moveScrollViewPage];
    }];
    
    [self.homeTitleView setItems:@[
        item1,
        item2,
        item3
    ]];
    
    [self performSelector:@selector(scrollView)];
}


- (UIBarButtonItem *)newUIBarButtonItemWithTarget:(id)target ImageName:(NSString *)imageNamed action:(SEL)action {
    UIImage *phoImage = [UIImage imageNamed:imageNamed];
    return [[UIBarButtonItem alloc] initWithImage:phoImage style:UIBarButtonItemStylePlain target:target action:action];
}

#pragma mark - getter & setter
- (WBONetKitTimeline *)netKit {
    if (!_netKit) {
        _netKit = [WBONetKitTimeline shareInstance];
    }
    return _netKit;
}

- (WBOHomeTitleView *)homeTitleView {
    if (!_homeTitleView) {
        _homeTitleView = [[WBOHomeTitleView alloc] initWithFrame:CGRectZero];
    }
    return _homeTitleView;
}

- (WBOHomeScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[WBOHomeScrollView alloc] initWithHomeTitleView:self.homeTitleView parentViewController:self];
    }
    return _scrollView;
}


#pragma mark - delegators

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    WBOLog(@"touch began");
//
////    WBOAuthorizationViewController *vc = [[WBOAuthorizationViewController alloc] init];
////
////    [self presentViewController:vc animated:YES completion:nil];
//
//    [self.netKit getPublicTimelineWithModel:[WBOTimeline class] completionHandler:^(NSURLResponse * _Nullable response, WBOModel * _Nullable model, NSError * _Nullable error) {
//        WBOTimeline *timeline = (WBOTimeline *)model;
//        WBOLog(@"mid = %@", timeline.mid);
//    }];
//
//}

- (void)didPressPhotobutton:(id)sender {
    WBOLog(@"button photo");
}


- (void)didPressRedPacketButton:(id)sender {
    WBOLog(@"red packet");
}

- (void)didPressMoreButton:(id)sender {
    WBOLog(@"red more");
}
@end
