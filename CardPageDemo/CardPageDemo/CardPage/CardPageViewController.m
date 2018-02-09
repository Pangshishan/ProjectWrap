//
//  CardPageViewController.m
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/7.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import "CardPageViewController.h"
#import "ItemViewController.h"

typedef enum : NSUInteger {
    PageDirectionNoChange,
    PageDirectionLast,
    PageDirectionNext,
} PageDirectionType;

@interface CardPageViewController () <UIScrollViewDelegate>

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, strong) UIScrollView *scrollView;

// scrollView停留的页数(选中的vc的下标)
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *itemVCArray;

// 展示第几个数据
@property (nonatomic, assign) NSInteger dataIndex;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

// 位置属性
@property (nonatomic, assign) CGFloat edgeW;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat varHei;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat minWid;
@property (nonatomic, assign) CGFloat minHei;
@property (nonatomic, assign) CGFloat minScale;

@property (nonatomic, assign) NSInteger count;


@end

@implementation CardPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:panGes];
    self.panGesture = panGes;
    
    [self addScrollView];
    [self setPanGesturePrior];
}
- (void)dealloc
{
    NSLog(@"注销了");
}
- (void)addScrollView
{
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollV];
    scrollV.delegate = self;
    self.scrollView = scrollV;
    scrollV.backgroundColor = [UIColor blackColor];
    
    CGFloat screenWid = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHei = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat edgeW = 30; //
    CGFloat minWid = (screenWid - 2 * edgeW); // 最小宽度
    CGFloat minScale = (minWid / screenWid); // 最小比例
    CGFloat minHei = minScale * screenHei; // 最小高度
    
    CGFloat margin = 20; // 卡片间距
    CGFloat x = edgeW;
    CGFloat y = 64;
    CGFloat varHei = 64 - minScale * screenHei / 2;
    
    self.edgeW = edgeW;
    self.minWid = minWid;
    self.minScale = minScale;
    self.minHei = minHei;
    self.margin = margin;
    self.varHei = varHei;
    self.minY = y;
    
    
    self.count = 7;
    NSInteger count = self.count > 2 ? 3 : self.count;
    
    scrollV.contentSize = CGSizeMake(edgeW * 2 + self.count * minWid + (self.count - 1) * margin, self.view.bounds.size.height);
    scrollV.showsVerticalScrollIndicator = NO;

    self.itemVCArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        ItemViewController *itemVC = [[ItemViewController alloc] init];
        [self addChildViewController:itemVC];
        [scrollV addSubview:itemVC.view];
        itemVC.view.frame = CGRectMake(x + i * (minWid + margin), y, minWid, minHei);
        [self.itemVCArray addObject:itemVC];
        [itemVC reloadWithData:nil index:i];
    }
    
}
- (void)setPanGesturePrior
{
    for (int i = 0; i < self.itemVCArray.count; i++) {
        ItemViewController *itemVC = self.itemVCArray[i];
        [itemVC.tableView.panGestureRecognizer requireGestureRecognizerToFail:self.panGesture];
    }
}
- (void)setItemsVCPrior
{
    for (int i = 0; i < self.itemVCArray.count; i++) {
        ItemViewController *itemVC = self.itemVCArray[i];
        [self.panGesture requireGestureRecognizerToFail:itemVC.tableView.panGestureRecognizer];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)panGes
{
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.startPoint = [panGes locationInView:self.view];
    } else if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGes locationInView:self.view];
        if (self.view.frame.origin.y + point.y - self.startPoint.y < self.startFrame.origin.y) {
            return;
        }
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + point.y - self.startPoint.y, self.view.bounds.size.width, self.view.bounds.size.height);
    } else if (panGes.state == UIGestureRecognizerStateEnded) {
        if (self.view.frame.origin.y - self.startFrame.origin.y > 100) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(self.startFrame.origin.x, self.startFrame.origin.y + self.startFrame.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
            }];
        } else {
            if (self.view.frame.origin.y != self.startFrame.origin.y) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.view.frame = self.startFrame;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
#pragma mark - scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = *targetContentOffset;
    CGFloat targetX = targetOffset.x;

    CGFloat now_X = self.pageIndex * (_minWid + _margin); // 当前页x坐标
    CGFloat lastX = (self.pageIndex - 1) * (_minWid + _margin);
    CGFloat nextX = (self.pageIndex + 1) * (_minWid + _margin);
    
    PageDirectionType directionType;
    
    if (targetX < (lastX + self.view.bounds.size.width / 2)) { // 上一页
        [scrollView setContentOffset:CGPointMake(lastX, targetOffset.y) animated:YES];
        self.pageIndex--;
        directionType = PageDirectionLast;
    } else if (targetX > (nextX - self.view.bounds.size.width / 2)) { // 下一页
        [scrollView setContentOffset:CGPointMake(nextX, targetOffset.y) animated:YES];
        self.pageIndex++;
        directionType = PageDirectionNext;
    } else {
        [scrollView setContentOffset:CGPointMake(now_X, targetOffset.y) animated:YES];
        directionType = PageDirectionNoChange;
    }
    (*targetContentOffset).x = scrollView.contentOffset.x;
    NSLog(@"第 %ld 页", self.pageIndex);
    if (directionType == PageDirectionNext) {
        if (self.pageIndex == 1 || self.pageIndex == self.count - 1) {
            return;
        }
        ItemViewController *vc = self.itemVCArray[[self farthestIndexWithLeft:YES]];
        vc.view.frame = CGRectMake(self.edgeW + (self.pageIndex + 1) * (self.minWid + self.margin), self.minY, self.minWid, self.minHei);
        [vc reloadWithData:nil index:self.pageIndex + 1];
    } else if (directionType == PageDirectionLast) {
        if (self.pageIndex == self.count - 2 || self.pageIndex == 0) {
            return;
        }
        ItemViewController *vc = self.itemVCArray[[self farthestIndexWithLeft:NO]];
        vc.view.frame = CGRectMake(self.edgeW + (self.pageIndex - 1) * (self.minWid + self.margin), self.minY, self.minWid, self.minHei);
        [vc reloadWithData:nil index:self.pageIndex - 1];
    }
}
- (NSInteger)farthestIndexWithLeft:(BOOL)isLeft
{
    CGRect markFrame = ((UIViewController *)self.itemVCArray.firstObject).view.frame;
    NSInteger index = 0;
    for (int i = 0; i < self.itemVCArray.count; i++) {
        CGRect indexFrame = ((UIViewController *)self.itemVCArray[i]).view.frame;
        BOOL condition = (isLeft ? (indexFrame.origin.x < markFrame.origin.x) : (indexFrame.origin.x > markFrame.origin.x));
        if (condition) {
            markFrame = indexFrame;
            index = i;
        }
    }
    return index;
}
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    NSLog(@"第 %ld 页", self.pageIndex);
//    if (self.pageIndex == 0 || self.pageIndex == self.count - 1) {
//        return;
//    }
//
//}



#pragma mark - privite func



@end





