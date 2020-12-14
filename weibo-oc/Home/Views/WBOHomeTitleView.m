//
//  WBOHomeTitleView.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/14.
//

#import "WBOHomeTitleView.h"
#import "WBOHomeTitleUIButton.h"

@interface WBOHomeTitleView()

@property (nonatomic, strong) WBOHomeTitleUIButton *followBtn;

@property (nonatomic, strong) WBOHomeTitleUIButton *recommendBtn;

@end

@implementation WBOHomeTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.followBtn];
    [self addSubview:self.recommendBtn];
    
    // 为选中的index设置监听
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedItemIndex)) options:NSKeyValueObservingOptionNew context:nil];
    // 为index设置默认值0
    self.selectedItemIndex = 0;
    
    [self.followBtn addTarget:self action:@selector(followList:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.recommendBtn addTarget:self action:@selector(recommendList:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedItemIndex))]) {
        BOOL selectedFollowers = self.selectedItemIndex == 0;
        self.followBtn.tabSelected = selectedFollowers;
        self.recommendBtn.tabSelected = !selectedFollowers;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_centerX).with.offset(-15);
        make.height.mas_equalTo(42);
    }];
    
    [self.recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.mas_centerX).with.offset(15);
        make.height.mas_equalTo(42);
    }];
    
}

#pragma mark getter
- (WBOHomeTitleUIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [[WBOHomeTitleUIButton alloc] init];
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_followBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _followBtn;
}

- (WBOHomeTitleUIButton *)recommendBtn {
    if (!_recommendBtn) {
        _recommendBtn = [[WBOHomeTitleUIButton alloc] init];
        [_recommendBtn setTitle:@"推荐" forState:UIControlStateNormal];
    }
    return _recommendBtn;
}

- (void)followList:(id)sender {
    WBOLog(@"touch followers");
    self.selectedItemIndex = 0;
}

- (void)recommendList:(id)sender {
    WBOLog(@"touch recommends");
    self.selectedItemIndex = 1;
}

@end
