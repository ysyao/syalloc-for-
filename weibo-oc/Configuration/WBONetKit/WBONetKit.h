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

typedef enum : NSUInteger {
    GET,
    POST
} ReqMethod;

/// 网络工具封装Root类
@interface WBONetKit : NSObject


/// 单例模式
+ (instancetype)shareInstance;


/// 组装get请求参数
/// @param urlString 请求url
/// @param parameters 参数
/// @param error 错误
- (nullable NSMutableURLRequest *)getReq:(NSString *)urlString parameters:(nullable id)parameters error:(NSError * _Nullable __autoreleasing * _Nullable)error;


/// 组装post请求参数
/// @param urlString 请求url
/// @param parameters 参数
/// @param error 错误
- (nullable NSMutableURLRequest *)postReq:(NSString *)urlString parameters:(nullable id)parameters error:(NSError * _Nullable __autoreleasing * _Nullable)error;


/// 发送请求，并指定解析自定义类
/// @param method 请求类型：GET，POST
/// @param urlStr 请求
/// @param parameters 参数
/// @param clazz 解析自定义类类型
/// @param completionHandler 请求回调
- (void)composeAndSendRequestWithMethod:(ReqMethod)method urlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters clazz:(Class)clazz completionHandler:(void (^)(NSURLResponse * _Nullable response, WBOModel * _Nullable model, NSError * _Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
