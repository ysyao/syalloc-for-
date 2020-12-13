//
//  WBONetKitTimeline.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/13.
//

#import "WBONetKitTimeline.h"

@interface WBONetKitTimeline()

@end

@implementation WBONetKitTimeline

#pragma mark - API接口实现


/// 请求timeline数据
/// @param clazz 解析class
/// @param completionHandler 成功回调
- (void)getPublicTimelineWithModel:(Class)clazz completionHandler:(void (^)(NSURLResponse * _Nullable response, WBOModel * _Nullable model, NSError * _Nullable error))completionHandler {
    NSDictionary *parameters = @{
        @"access_token": ACCESS_TOKEN,
        @"count": @(5)
    };
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SINA_HOST, PUBLIC_TIMELINE];
    
    [self composeAndSendRequest:urlStr parameters:parameters class:clazz completionHandler:completionHandler];
}

@end
