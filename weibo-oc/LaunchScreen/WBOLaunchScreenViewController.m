//
//  WBOLaunchScreenViewController.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/15.
//

#import "WBOLaunchScreenViewController.h"
#import "WBOHomeViewController.h"
#import "WBOMessageViewController.h"
#import "WBOMeViewController.h"
#import "SDWebImage.h"

/// https://stackoverflow.com/questions/52984478/gif-in-launch-screen
/// You can not use Custom classes in Launchscreen. Create a UIViewController and mark it as an entry point. Play the gif there and after a certain time you perform a segue to other ViewController. This little trick will work
/// 不能用苹果自带的launchScreen展示gif，因为不能再其中关联自定义viewcontroller，只能新建一个vc，然后将其在appdelegator中设置成为入口vc。
@interface WBOLaunchScreenViewController ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@property (nonatomic, strong) UIButton *cdBtn;

@property (nonatomic, assign) int secondsCountDown;

@end

@implementation WBOLaunchScreenViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self newAnimationImageView];
    
    [self newSecondCountUIButton];
    
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(secondsCountDown))];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(secondsCountDown))]) {
        if (self.secondsCountDown <= 0) {
            [self replaceKeyWindowRootViewControllerWithAnimation];
            return;
        }
        NSString *title = [NSString stringWithFormat:@"跳转 %d", self.secondsCountDown];
        [self.cdBtn setTitle:title forState:UIControlStateNormal];
        
        
        weakSelf();
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.secondsCountDown -= 1;
        });
        
    }
    
}

#pragma mark - new UIViews
- (void)newAnimationImageView {
    
    /// 新建gif
    SDAnimatedImageView *gifIv = [[SDAnimatedImageView alloc] initWithFrame:self.view.bounds];
    SDAnimatedImage *animatedImage = [SDAnimatedImage imageNamed:@"screen_bg2.gif"];
    gifIv.image = animatedImage;
    gifIv.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview: gifIv];
}

- (void)newSecondCountUIButton {
    UIButton *btn = [[UIButton alloc] init];
    btn.layer.cornerRadius = 20;
    btn.layer.borderColor = [UIColor.whiteColor CGColor];
    btn.layer.borderWidth = 1;
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn addTarget:self action:@selector(replaceKeyWindowRootViewControllerWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    self.cdBtn = btn;
    [self.view addSubview:self.cdBtn];
    

    [self.cdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(50);
        make.trailing.mas_equalTo(self.view.mas_trailing).with.offset(-30);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
    
    // 添加监听器
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(secondsCountDown)) options:NSKeyValueObservingOptionNew context:nil];
    
    // 设置初始值，触发监听器
    self.secondsCountDown = 5;
}

#pragma mark - getters

- (UITabBarController *)tabBarController {
    if (!_tabBarController) {
        UITabBarController *tabVc = [[UITabBarController alloc] init];
        
        tabVc.tabBar.tintColor = UIColor.blackColor;
        UINavigationController *timeLineVc = [WBOUtils newNavigationControlerBy:[WBOHomeViewController class]];
        UINavigationController *videoVc = [WBOUtils newNavigationControlerBy:[WBOMessageViewController class]];
        UINavigationController *findVc = [WBOUtils newNavigationControlerBy:[WBOMessageViewController class]];
        UINavigationController *msgVc = [WBOUtils newNavigationControlerBy:[WBOMessageViewController class]];
        UINavigationController *meVc = [WBOUtils newNavigationControlerBy:[WBOMeViewController class]];
        
        [WBOUtils setTabBarItem:timeLineVc WithImageName:@"timeline" title:@"微博"];
        [WBOUtils setTabBarItem:videoVc WithImageName:@"video" title:@"视频"];
        [WBOUtils setTabBarItem:findVc WithImageName:@"search" title:@"发现"];
        [WBOUtils setTabBarItem:msgVc WithImageName:@"message" title:@"私信"];
        [WBOUtils setTabBarItem:meVc WithImageName:@"me" title:@"我"];
        
        tabVc.viewControllers = @[timeLineVc, videoVc, findVc, msgVc, meVc];
        _tabBarController = tabVc;
    }
    return _tabBarController;
}

- (void)replaceKeyWindowRootViewControllerWithAnimation {
    
    /// 替换keywindow
    /// https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0
    /// How to resolve: 'keyWindow' was deprecated in iOS 13.0
    UIWindow *keyWindow = [WBOUtils findKeyWindow:[UIApplication sharedApplication].windows];
    if (keyWindow) {
        keyWindow.rootViewController = self. tabBarController;
        /// view动画
        /// https://stackoverflow.com/questions/41144523/swap-rootviewcontroller-with-animation
        /// Swap rootViewController with animation?
        [UIView transitionWithView:keyWindow duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    }
}

@end
