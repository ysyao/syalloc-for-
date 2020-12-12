//
//  WBOHomeViewController.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/12.
//

#import "WBOHomeViewController.h"
#import "WBOAuthorizationViewController.h"

@interface WBOHomeViewController ()

@end

@implementation WBOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WBOLog(@"home controller");
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WBOLog(@"touch began");
    
    WBOAuthorizationViewController *vc = [[WBOAuthorizationViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
