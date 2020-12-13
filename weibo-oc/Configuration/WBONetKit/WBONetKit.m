//
//  WBONetKit.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/13.
//

#import "WBONetKit.h"
@interface WBONetKit()

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

@property (nonatomic, strong) AFHTTPRequestSerializer *reqSerializer;

@end

@implementation WBONetKit

+ (instancetype)shareInstance {
    static WBONetKit *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[self alloc] init];
    });
    
    return sInstance;
}

#pragma mark - getters

- (AFURLSessionManager *)sessionManager {
    if (!_sessionManager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _sessionManager;
}

- (AFHTTPRequestSerializer *)reqSerializer {
    if (!_reqSerializer) {
        _reqSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _reqSerializer;
}

#pragma mark - 公共方法实现

- (nullable NSURLRequest *)getReq:(NSString *)urlString parameters:(nullable id)parameters error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSMutableURLRequest *mutiReq = [self.reqSerializer requestWithMethod:@"GET" URLString:urlString parameters:parameters error:error];
    
    return [mutiReq copy];
}

- (nullable NSURLRequest *)postReq:(NSString *)urlString parameters:(nullable id)parameters error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSMutableURLRequest *mutiReq = [self.reqSerializer requestWithMethod:@"POST" URLString:urlString parameters:parameters error:error];
    return [mutiReq copy];
}

- (void)composeAndSendRequest:(NSString *)urlStr parameters:(NSDictionary *)parameters class:(Class)clazz completionHandler:(void (^)(NSURLResponse * _Nullable response, WBOModel * _Nullable model, NSError * _Nullable error))completionHandler {
    
    NSError *error;
    NSURLRequest *req = [self getReq:urlStr parameters:parameters error:&error];
    
    if (error) {
        completionHandler(nil, nil, error);
        return;
    }
    
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            WBOLog(@"Error: %@", error);
        } else {
            WBOModel *m = [clazz yy_modelWithJSON:responseObject];
            completionHandler(response, m, error);
        }
    }];
    
    [task resume];
}


@end
