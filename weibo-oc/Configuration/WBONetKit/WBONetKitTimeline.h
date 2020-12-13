//
//  WBONetKitTimeline.h
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/13.
//

#import "WBONetKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBONetKitTimeline : WBONetKit


/// 读取个人timeline
/// @param completionHandler 成功回调
- (void)getPublicTimelineWithModel:(Class)clazz completionHandler:(void (^)(NSURLResponse * _Nullable response, WBOModel * _Nullable model, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
