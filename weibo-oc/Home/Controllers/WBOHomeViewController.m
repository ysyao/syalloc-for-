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

@interface WBOHomeViewController ()

@property (nonatomic, strong) WBONetKitTimeline *netKit;

@end

@implementation WBOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WBOLog(@"home view controller");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WBOLog(@"touch began");
    
//    WBOAuthorizationViewController *vc = [[WBOAuthorizationViewController alloc] init];
//
//    [self presentViewController:vc animated:YES completion:nil];
    
    
//    [self.netKit getPublicTimeline:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (error) {
//            WBOLog(@"Error: %@", error);
//        } else {
//            WBOLog(@"%@", responseObject[@"statuses"][0][@"idstr"]);
//        }
//
//    }];
    
    [self.netKit getPublicTimelineWithModel:[WBOTimeline class] completionHandler:^(NSURLResponse * _Nullable response, WBOModel * _Nullable model, NSError * _Nullable error) {
        WBOTimeline *timeline = (WBOTimeline *)model;
        WBOLog(@"mid = %@", timeline.mid);
    }];

}

#pragma mark - getter & setter
- (WBONetKitTimeline *)netKit {
    if (!_netKit) {
        _netKit = [WBONetKitTimeline shareInstance];
    }
    return _netKit;
}

@end
