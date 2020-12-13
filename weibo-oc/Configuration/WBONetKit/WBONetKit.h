//
//  WBONetKit.h
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/13.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "WBONetKitConstants.h"
#import "WBOModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBONetKit : NSObject

+ (instancetype)shareInstance;

- (nullable NSMutableURLRequest *)getReq:(NSString *)urlString parameters:(nullable id)parameters error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (nullable NSMutableURLRequest *)postReq:(NSString *)urlString parameters:(nullable id)parameters error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (void)composeAndSendRequest:(NSString *)urlStr parameters:(NSDictionary *)parameters class:(Class)clazz completionHandler:(void (^)(NSURLResponse * _Nullable response, WBOModel * _Nullable model, NSError * _Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
