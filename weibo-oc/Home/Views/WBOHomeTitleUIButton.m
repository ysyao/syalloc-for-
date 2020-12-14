//
//  WBOHomeTitleUIButton.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/14.
//

#import "WBOHomeTitleUIButton.h"

@implementation WBOHomeTitleUIButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(tabSelected)) options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(tabSelected))]) {

        if (self.tabSelected) {
            self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
            
            /// https://stackoverflow.com/questions/6703699/uibutton-title-text-color
            /// [headingButton setTitleColor:[UIColor colorWithRed:36/255.0 green:71/255.0 blue:113/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        } else {
            self.titleLabel.font = [UIFont systemFontOfSize:17];
            [self setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        }
    }
}

@end
