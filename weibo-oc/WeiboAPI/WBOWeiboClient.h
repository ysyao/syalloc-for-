//
//  WBOWeiboClient.h
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBOWeiboClient : NSObject

+ (instancetype)shareInstance;

+ (NSURL *)oathu2;

+ (NSString *)callbackHost;

@end

NS_ASSUME_NONNULL_END
