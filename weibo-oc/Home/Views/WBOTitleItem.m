//
//  WBOTitleItem.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/15.
//

#import "WBOTitleItem.h"

@implementation WBOTitleItem

- (instancetype)initWithTitle:(NSString *)title Block:(WboTitleItemBlock)block
{
    self = [super init];
    if (self) {
        self.title = title;
        self.block = block;
    }
    return self;
}

@end
