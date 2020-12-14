//
//  WBOUtils.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/12.
//

#import "WBOUtils.h"

@implementation WBOUtils

+ (void)setTabBarItem:(UIViewController *)viewController WithImageName:(NSString *)imageName title:(NSString *)title {
    UIImage *img = [UIImage imageNamed:imageName];
    UIImage *selectedImg = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", imageName]];
    
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:img selectedImage:selectedImg];
    
}

+ (UINavigationController *)newNavigationControlerBy:(Class)clazz {
    NSObject *obj = [[clazz alloc] init];
    if ([obj isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)obj;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        return nav;
    }
    return nil;
}

@end

