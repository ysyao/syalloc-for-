//
//  WBOAuthorizationViewController.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/12.
//  内部新建一个webview，跳转到sina的author2.0授权页面，等授权成功回调拦截

#import "WBOAuthorizationViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WKNavigationDelegate.h>
#import <WebKit/WKNavigationAction.h>
#import "WBOWeiboClient.h"

@interface WBOAuthorizationViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) UINavigationBar *navBar;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UINavigationItem *navItem;

@property (nonatomic, strong) WKWebView *wbView;

@property (nonatomic, strong) WBOWeiboClient *wbClient;

- (void)addConstraints;

@end

@implementation WBOAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.view setBackgroundColor:UIColor.whiteColor];
    
    [self addConstraints];
    
    NSURL *url = [WBOWeiboClient oathu2];

    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    [self.wbView loadRequest:req];
}


/// 监听progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wbView) {
        // estimatedProgress is a value from 0.0 to 1.0
        // Update your UI here accordingly
        self.progressView.progress = self.wbView.estimatedProgress;
    }
    else if([keyPath isEqualToString:NSStringFromSelector(@selector(progress))]) {
        BOOL showProgress = self.wbView.estimatedProgress > 0 && self.wbView.estimatedProgress < 1;
        [self.progressView setHidden:!showProgress];
    }
    else {
        // Make sure to call the superclass's implementation in the else block in case it is also implementing KVO
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.wbView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.progressView removeObserver:self forKeyPath:NSStringFromSelector(@selector(progress))];
}

#pragma mark - delegator

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *strReq = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    if ([strReq hasPrefix:[WBOWeiboClient callbackHost]]) {
        WBOLog(@"拦截");
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - view constrains adding
- (void)addConstraints {
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.wbView];
    
    weakSelf();
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    [self.wbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.navBar.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navBar.mas_left);
        make.right.equalTo(self.navBar.mas_right);
        make.bottom.equalTo(self.navBar.mas_bottom);
    }];
}

#pragma mark - getter & setter
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        
        [_progressView addObserver:self forKeyPath:NSStringFromSelector(@selector(progress)) options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _progressView;
}

- (WBOWeiboClient *)wbClient {
    if (!_wbClient) {
        _wbClient = [WBOWeiboClient shareInstance];
    }
    return _wbClient;
}


/// navbar对应navigationItem数组，navigationitem对应了left、right和back的uibarbutton
- (UINavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[UINavigationBar alloc] init];
        
        [_navBar addSubview:self.progressView];
        [_navBar setItems:@[self.navItem]];
    }
    return _navBar;
}

- (UINavigationItem *)navItem {
    if (!_navItem) {
        _navItem = [[UINavigationItem alloc] initWithTitle:@"微博授权账号"];
        _navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    }
    return _navItem;
}

- (WKWebView *)wbView {
    if (!_wbView) {
        _wbView = [[WKWebView alloc] init];
        _wbView.navigationDelegate = self;
        [_wbView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:nil];
    }
    return _wbView;
}

#pragma mark - methods
- (void)cancel {
    WBOLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
