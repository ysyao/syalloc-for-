//
//  WBOWeiboClient.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/12.
//

#import "WBOWeiboClient.h"

@implementation WBOWeiboClient

+ (instancetype)shareInstance {
    static WBOWeiboClient *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[WBOWeiboClient alloc] init];
    });
    
    return sInstance;
}

+ (NSURL *)oathu2 {
    
    NSString *callback = [NSString stringWithFormat:@"%@", [WBOWeiboClient callbackHost]];
    
//    callback = [callback stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=2569839235&redirect_uri=%@", callback]];
}

+ (NSString *)callbackHost {
    return @"http://www.backresponse.com";
}


@end
