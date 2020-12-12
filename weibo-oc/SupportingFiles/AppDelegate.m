//
//  AppDelegate.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/12.
//

#import "AppDelegate.h"
#import "WBOHomeViewController.h"
#import "WBOMessageViewController.h"
#import "WBOMeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    UITabBarController *tabVc = [[UITabBarController alloc] init];
    
//    tabVc.tabBar.tintColor = MainThemeColor;
    
    WBOHomeViewController *timeLineVc = [[WBOHomeViewController alloc] init];
    WBOMessageViewController *msgVc = [[WBOMessageViewController alloc] init];
    WBOMeViewController *meVc = [[WBOMeViewController alloc] init];
    
    [WBOUtils setTabBarItem:timeLineVc WithImageName:@"timeline" title:@"信息流"];
    [WBOUtils setTabBarItem:msgVc WithImageName:@"message" title:@"私信"];
    [WBOUtils setTabBarItem:meVc WithImageName:@"me" title:@"我"];
    
    tabVc.viewControllers = @[timeLineVc, msgVc, meVc];
    
    self.window.rootViewController = tabVc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme isEqualToString:@"syalloc-wb-app"]) {
        NSLog(@"%@", url.path);
        return YES;
    }
    
    return YES;
}

#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
