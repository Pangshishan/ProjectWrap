//
//  CardPageItemVC.m
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/7.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import "CardPageItemVC.h"
#import <Masonry.h>

@interface CardPageItemVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) BOOL isTop;

@end

@implementation CardPageItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    self.isTop = YES;
    [self addTableView];
    
    if ([self.delegate respondsToSelector:@selector(itemVC:didChangeState:)]) {
        [self.delegate itemVC:self didChangeState:YES];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.tableView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
    self.label = label;
}

- (void)reloadWithData:(NSDictionary *)data index:(NSInteger)index
{
    self.index = index;
    self.label.text = [NSString stringWithFormat:@"%ld", index];
}
- (void)frameChanged
{
    //self.tableView.frame = self.view.bounds;
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.contentOffset = CGPointMake(0, 0);
}
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(itemVC:didChangeState:)]) {
        if (scrollView.contentOffset.y > 0) {
            if (self.isTop) {
                self.isTop = NO;
                [self.delegate itemVC:self didChangeState:NO];
            }
        } else {
            if (!self.isTop) {
                self.isTop = YES;
                [self.delegate itemVC:self didChangeState:YES];
            }
        }
    }
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}





@end







