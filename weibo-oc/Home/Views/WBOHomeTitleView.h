//
//  WBOHomeTitleView.h
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "WBOTitleItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBOHomeTitleView : UIView

@property (nonatomic, assign) NSUInteger selectedItemIndex;

@property (nonatomic, strong) NSArray<WBOTitleItem *> *items;



@end



NS_ASSUME_NONNULL_END
