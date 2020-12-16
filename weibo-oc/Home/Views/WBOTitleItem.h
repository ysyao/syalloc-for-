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

- (instancetype)initWithTitle:(NSString *)title indicatorColor:(UIColor *)indicatorColor viewControllerClass:(Class)viewControllerClass block:(WboTitleItemBlock)block;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) WboTitleItemBlock block;

@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, strong) Class viewControllerClass;

@end

NS_ASSUME_NONNULL_END
