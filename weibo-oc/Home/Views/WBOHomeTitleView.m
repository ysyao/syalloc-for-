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
    
    [self addSubview:self.indicatorStack];
    
    [self.titleStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(self.mas_leading);
        make.bottom.mas_equalTo(self.indicatorStack.mas_top);
        make.trailing.mas_equalTo(self.mas_trailing);
    }];
    
    [self.indicatorStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleStack.mas_bottom);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.bottom.mas_equalTo(self.mas_bottom);
//        make.height.mas_equalTo(2);
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
    /// 监听selectedItemIndex，如果改变会：
    /// 1.修改选中item对应的title外观风格，黑色加粗字体更大
    /// 2.修改选中item对应的indicator颜色
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedItemIndex))]) {
        if (self.titleStack.arrangedSubviews && self.titleStack.arrangedSubviews.count > 0) {
            for (UIView *subview in self.titleStack.arrangedSubviews) {
                if ([subview isKindOfClass:[WBOHomeTitleUIButton class]]) {
                    WBOHomeTitleUIButton *btn = (WBOHomeTitleUIButton *)subview;
                    btn.tabSelected = (btn.tag == self.selectedItemIndex);
                }
            }
            
            for (UIView *subview in self.indicatorStack.arrangedSubviews) {
                
//                UIColor *bgcolor = (subview.tag == self.selectedItemIndex) ? self.items[self.selectedItemIndex].indicatorColor : UIColor.clearColor;
                
                [subview.subviews.firstObject setBackgroundColor:UIColor.clearColor];
            }
        }
        [self performAnimateIndicator];
        return;
    }
    /// 监听items属性，当items设置值的时候会：
    /// 1.创建button 2.创建indicator
    else if([keyPath isEqualToString:NSStringFromSelector(@selector(items))]) {
        if (self.items && self.items.count > 0) {
            for (WBOTitleItem *item in self.items) {
                [self createButtonByItem:item];
                [self createIndicatorByItem:item];
            }
            self.selectedItemIndex = 0;
//            [self performAnimateIndicator];
        }
        return;
    }
}

- (void)createButtonByItem:(WBOTitleItem *)item {
    WBOHomeTitleUIButton *btn = [[WBOHomeTitleUIButton alloc] init];
    [btn setTitle:item.title forState:UIControlStateNormal];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    NSUInteger index = [self.items indexOfObject:item];
    [btn setTag:index];
    [btn addTarget:self action:@selector(titleItemTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleStack addArrangedSubview:btn];
}

- (void)createIndicatorByItem:(WBOTitleItem *)item {
    UIView *container = [[UIView alloc] init];
    NSUInteger index = [self.items indexOfObject:item];
    [container setTag:index];
    
    UIView *indicator = [[UIView alloc] init];
    indicator.layer.cornerRadius = 3;
    
    [container addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(2);
        make.centerX.mas_equalTo(container.mas_centerX);
        make.centerY.mas_equalTo(container.mas_centerY);
    }];

    [self.indicatorStack addArrangedSubview:container];
}

- (void)setUpAnimateIndicatorGradientColorByMutiplier:(int)mutiplier {
    // 设置渐变色
    UIView *indicator = self.animateIndicator;
    [indicator.layer.sublayers.firstObject removeFromSuperlayer];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = indicator.bounds;
    
    NSMutableArray *itemColors = [[NSMutableArray alloc] init];
    
    if (mutiplier < 0) {
        if ((self.selectedItemIndex - 1) < 0) {
            [itemColors addObject:(__bridge id)self.items[self.selectedItemIndex].indicatorColor.CGColor];
        } else {
            [itemColors addObject:(__bridge id)self.items[self.selectedItemIndex - 1].indicatorColor.CGColor];
            [itemColors addObject:(__bridge id)self.items[self.selectedItemIndex].indicatorColor.CGColor];
        }
    } else if(mutiplier > 0) {
        if ((self.selectedItemIndex + 1) == self.items.count) {
            [itemColors addObject:(__bridge id)self.items[self.selectedItemIndex].indicatorColor.CGColor];
        } else {
            [itemColors addObject:(__bridge id)self.items[self.selectedItemIndex].indicatorColor.CGColor];
            [itemColors addObject:(__bridge id)self.items[self.selectedItemIndex + 1].indicatorColor.CGColor];
        }
    } else {
        [self.animateIndicator.layer.sublayers.firstObject removeFromSuperlayer];
        CALayer *layer = [CALayer new];
        layer.frame = self.animateIndicator.bounds;
        [self.animateIndicator.layer addSublayer:layer];
        [self.animateIndicator.layer setBackgroundColor:self.items[self.selectedItemIndex].indicatorColor.CGColor];
//        [itemColors addObject:(__bridge id)self.items[self.selectedItemIndex].indicatorColor.CGColor];
//        [itemColors addObject:(__bridge id)self.items[self.selectedItemIndex].indicatorColor.CGColor];
        return;
    }
    
    gradient.colors = [itemColors copy];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);

    [indicator.layer addSublayer:gradient];
}

/// 将带有动画的indicator设置到某个indicatorstack下去并制定颜色
- (void)performAnimateIndicator {
    if (!self.indicatorStack.arrangedSubviews || self.indicatorStack.arrangedSubviews.count < 1 || !self.items || self.items.count < 1) {
        return;
    }
    UIView *anchor = self.indicatorStack.arrangedSubviews[self.selectedItemIndex];
    [self.animateIndicator removeFromSuperview];
    [anchor addSubview:self.animateIndicator];
    
    [self setUpAnimateIndicatorGradientColorByMutiplier:0];
//    [self.animateIndicator setBackgroundColor:self.items[self.selectedItemIndex].indicatorColor];
    [self.animateIndicator mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(2);
        make.centerX.mas_equalTo(anchor.mas_centerX);
        make.centerY.mas_equalTo(anchor.mas_centerY);
    }];
}

#pragma mark getter

- (UIView *)animateIndicator {
    if (!_animateIndicator) {
        _animateIndicator = [[UIView alloc] init];
        _animateIndicator.layer.cornerRadius = 3;
        [_animateIndicator setBackgroundColor:UIColor.blackColor];
    }
    return _animateIndicator;
}

- (UIStackView *)indicatorStack {
    if (!_indicatorStack) {
        _indicatorStack = [[UIStackView alloc] init];
        [_indicatorStack setAlignment:UIStackViewAlignmentCenter];
        [_indicatorStack setDistribution:UIStackViewDistributionFillEqually];
//        [_indicatorStack setLayoutMargins:UIEdgeInsetsMake(0, 30, 0, 30)];
//        [_indicatorStack setDirectionalLayoutMargins:NSDirectionalEdgeInsetsMake(0, 30, 0, 30)];
//        [_indicatorStack setSpacing:50];
    }
    return _indicatorStack;
}

- (UIStackView *)titleStack {
    if (!_titleStack) {
        _titleStack = [[UIStackView alloc] init];
        [_titleStack setAlignment:UIStackViewAlignmentCenter];
        [_titleStack setDistribution:UIStackViewDistributionFillEqually];
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
