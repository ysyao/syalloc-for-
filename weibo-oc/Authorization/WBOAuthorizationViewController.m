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

@interface WBOAuthorizationViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) UINavigationBar *navBar;

@property (nonatomic, strong) UINavigationItem *navItem;

@property (nonatomic, strong) WKWebView *wbView;

- (void)addConstraints;

@end

@implementation WBOAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.view setBackgroundColor:UIColor.whiteColor];
    
    [self addConstraints];
    
    NSString *backUrl = [@"https://backresponse.com/oauth2/back&response_type=code" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=2569839235&redirect_uri=%@", backUrl]];
    // https://api.weibo.com/oauth2/authorize?client_id=123050457758183&redirect_uri=http://www.example.com/response&response_type=code

    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    [self.wbView loadRequest:req];
}

#pragma mark - delegator
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *strReq = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    if ([strReq hasPrefix:@"https://backresponse.com/oauth2/back"]) {
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
    
    WEAKSELF;
    
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
}

#pragma mark - getter & setter
- (UINavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[UINavigationBar alloc] init];
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
    }
    return _wbView;
}

#pragma mark - methods
- (void)cancel {
    WBOLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
