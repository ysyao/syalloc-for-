//
//  WBOHomeScrollView.h
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/16.
//

#import <UIKit/UIKit.h>
#import "WBOHomeTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBOHomeScrollView : UIScrollView

- (instancetype)initWithHomeTitleView:(WBOHomeTitleView *)titleView parentViewController:(UIViewController *)parentViewController;

- (void)moveScrollViewPage;
@end

NS_ASSUME_NONNULL_END
