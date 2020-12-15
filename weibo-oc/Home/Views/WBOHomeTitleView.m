//
//  WBOHomeTitleView.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/14.
//

#import "WBOHomeTitleView.h"
#import "WBOHomeTitleUIButton.h"

@interface WBOHomeTitleView()

@property (nonatomic, strong) UIStackView *titleStack;

@end


@implementation WBOHomeTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}


#pragma mark - 初始化view
- (void)initSubviews {
    [self addSubview:self.titleStack];
    
    [self.titleStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(self.mas_leading);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.trailing.mas_equalTo(self.mas_trailing);
    }];
    
    
    // 为选中的index设置监听
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedItemIndex)) options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(items)) options:NSKeyValueObservingOptionNew context:nil];
    
    
    // 为index设置默认值0
    self.selectedItemIndex = 0;
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

#pragma mark - 继承方法

- (void)dealloc
{
    if (self.titleStack.subviews && self.titleStack.subviews.count > 0) {
        for (UIView *subview in self.titleStack.subviews) {
            if ([subview isKindOfClass:[WBOHomeTitleUIButton class]]) {
                WBOHomeTitleUIButton *btn = (WBOHomeTitleUIButton *)subview;
                [btn removeTarget:self action:@selector(titleItemTouched:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(items))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedItemIndex))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    WBOLog(@"listen keypath : %@", keyPath);
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedItemIndex))]) {
        if (self.titleStack.subviews && self.titleStack.subviews.count > 0) {
            for (UIView *subview in self.titleStack.subviews) {
                if ([subview isKindOfClass:[WBOHomeTitleUIButton class]]) {
                    WBOHomeTitleUIButton *btn = (WBOHomeTitleUIButton *)subview;
                    btn.tabSelected = (btn.tag == self.selectedItemIndex);
                }
            }
        }
        return;
    }
    else if([keyPath isEqualToString:NSStringFromSelector(@selector(items))]) {
        if (self.items && self.items.count > 0) {
            for (WBOTitleItem *item in self.items) {
                WBOHomeTitleUIButton *btn = [[WBOHomeTitleUIButton alloc] init];
                [btn setTitle:item.title forState:UIControlStateNormal];
                [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
                NSUInteger index = [self.items indexOfObject:item];
                [btn setTag:index];
                [btn addTarget:self action:@selector(titleItemTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.titleStack addArrangedSubview:btn];
            }
            self.selectedItemIndex = 0;
        }
        return;
    }
}

#pragma mark getter

- (UIStackView *)titleStack {
    if (!_titleStack) {
        _titleStack = [[UIStackView alloc] init];
        [_titleStack setAlignment:UIStackViewAlignmentCenter];
        [_titleStack setDistribution:UIStackViewDistributionFillEqually];
        _titleStack.spacing = 25;
    }
    
    return _titleStack;
}


#pragma mark - 事件
- (void)titleItemTouched:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        [self findItemAndFireBlock:btn.tag];
    }
    
}

- (void)findItemAndFireBlock:(long)tag {
    if (self.items && self.items.count > 0) {
        for (WBOTitleItem *item in self.items) {
            NSUInteger index = [self.items indexOfObject:item];
            if (index == tag) {
                self.selectedItemIndex = index;
                item.block(item.title, index);
            }
        }
    }
}

@end
