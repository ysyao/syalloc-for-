//
//  WBOTimeline.h
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/13.
//

#import "WBOModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBOTimeline : WBOModel

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *text;


@end

NS_ASSUME_NONNULL_END
