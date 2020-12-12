//
//  WBOUtils.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/12.
//

#import "WBOUtils.h"

@implementation WBOUtils

+ (void)setTabBarItem:(UIViewController *)viewController WithImageName:(NSString *)imageName title:(NSString *)title {
    UIImage *timelineImg = [UIImage imageNamed:imageName];
    
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:timelineImg selectedImage:timelineImg];
    
}

@end

