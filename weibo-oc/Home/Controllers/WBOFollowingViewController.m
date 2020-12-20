//
//  WBOFollowingViewController.m
//  weibo-oc
//
//  Created by 易诗尧 on 2020/12/16.
//

#import "WBOFollowingViewController.h"
#import "MJRefresh.h"

@interface WBOFollowingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *timelines;

@property (nonatomic, strong) MJRefreshNormalHeader *timelineHeader;

@end

@implementation WBOFollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.timelines];
    
    [_timelines setMj_header:self.timelineHeader];
    
//    [self.timelines mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.mas_top);
//        make.bottom.mas_equalTo(self.view.mas_bottom);
//        make.leading.mas_equalTo(self.view.mas_leading);
//        make.trailing.mas_equalTo(self.view.mas_trailing);
//    }];
    
    
    [self.timelines registerClass:[UITableViewCell class] forCellReuseIdentifier:@"sojustsoso"];
    
}

#pragma mark - delegator
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.timelines.frame.size.width, 80)];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 60;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 120;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.timelines.frame.size.width, 120)];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sojustsoso" forIndexPath:indexPath];
    
    if (indexPath.row % 2 == 0) {
        [cell.contentView.layer setBackgroundColor:UIColor.redColor.CGColor];
    } else {
        [cell.contentView.layer setBackgroundColor:UIColor.blueColor.CGColor];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


#pragma mark - getter

- (UITableView *)timelines {
    if (!_timelines) {
        _timelines = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        
//
//        MJRefreshAutoNormalFooter *footer = [[MJRefreshAutoNormalFooter alloc] init];
//        [_timelines setMj_footer:footer];
        
        [_timelines setAlwaysBounceVertical:NO];
        [_timelines setAlwaysBounceHorizontal:NO];
        [_timelines setShowsVerticalScrollIndicator:NO];
        _timelines.delegate = self;
        _timelines.dataSource = self;
    }
    
    return _timelines;
}

- (MJRefreshNormalHeader *)timelineHeader {
    if (!_timelineHeader) {
        weakSelf();
        _timelineHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.timelineHeader endRefreshing];
            });
        }];
        
    }
    return _timelineHeader;
}









@end
