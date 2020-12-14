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

@interface WBOHomeViewController ()


@property (nonatomic, strong) WBONetKitTimeline *netKit;

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
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    [leftPhotoItem setTintColor:UIColor.blackColor];
    [rightRedPacketItem setTintColor:UIColor.redColor];
    [rightMoreItem setTintColor:[UIColor orangeColor]];
    
    self.navigationItem.leftBarButtonItem = leftPhotoItem;
    self.navigationItem.rightBarButtonItems = @[rightMoreItem, rightRedPacketItem, fixed];
    
    WBOHomeTitleView *tv = [[WBOHomeTitleView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.navigationItem.titleView = tv;
    
//    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(self.navigationItem.titleView.mas_leading);
//        make.top.mas_equalTo(self.navigationItem.titleView.mas_top);
//        make.trailing.mas_equalTo(self.navigationItem.titleView.mas_trailing);
//        make.bottom.mas_equalTo(self.navigationItem.titleView.mas_bottom);
//    }];
    
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

#pragma mark - getters



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
