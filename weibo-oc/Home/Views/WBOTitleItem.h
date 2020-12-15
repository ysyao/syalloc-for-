//
//  WBOTitleItem.h
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WboTitleItemBlock)(NSString *title, NSUInteger index);

@interface WBOTitleItem : NSObject

- (instancetype)initWithTitle:(NSString *)title Block:(WboTitleItemBlock)block;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) WboTitleItemBlock block;

@end

NS_ASSUME_NONNULL_END
