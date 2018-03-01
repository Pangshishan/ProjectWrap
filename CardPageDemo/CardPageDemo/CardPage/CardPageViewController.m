//
//  CardPageViewController.m
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/7.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import "CardPageViewController.h"
#import "CardPageItemVC.h"
#import "CardPageVCView.h"

typedef enum : NSUInteger {
    PageDirectionNoChange,
    PageDirectionLast,
    PageDirectionNext,
} PageDirectionType;

typedef enum : NSUInteger {
    DraggingDirectionUp,
    DraggingDirectionDown,
    DraggingDirectionLeftAndRight,
} DraggingDirection;

typedef enum : NSUInteger {
    CardStateNormal,
    CardStateFullScreen,
} CardState;

@interface CardPageViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, CardPageVCHitDelegate, WishCardPageProtocol>

@property (nonatomic, assign) CGRect startFrame;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *itemVCArray;

@property (nonatomic, assign) DraggingDirection dragDirection;
@property (nonatomic, assign) BOOL havingSetDrag;

@property (nonatomic, assign) CardState cardState;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) CGFloat panHeight;

// 位置属性
@property (nonatomic, assign) CGFloat edgeW;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat varHei;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat minWid;
@property (nonatomic, assign) CGFloat minHei;
@property (nonatomic, assign) CGFloat minScale;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UITouch *panTouch;
@property (nonatomic, assign) BOOL isTop;


@end

@implementation CardPageViewController

- (void)loadView
{
    [super loadView];
    CardPageVCView *cardView = [[CardPageVCView alloc] initWithFrame:self.view.frame];
    cardView.delegate = self;
    self.view = cardView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.startFrame = self.view.frame;
    [self setupPanGesture];
    [self addScrollView];
    [self setPanGesturePrior];
}
- (void)dealloc
{
    NSLog(@"注销了");
}
- (void)setupPanGesture
{
    if (self.panGesture) {
        // [self.panGesture removeTarget:self action:@selector(panGesture)];
        [self.view removeGestureRecognizer:self.panGesture];
        self.panGesture = nil;
    }
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:panGes];
    panGes.delegate = self;
    panGes.delaysTouchesEnded = NO;
    self.panGesture = panGes;
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
    CGFloat varHei = 64 - (screenHei - minScale * screenHei) / 2;
    
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
        CardPageItemVC *itemVC = [[CardPageItemVC alloc] init];
        itemVC.delegate = self;
        [self addChildViewController:itemVC];
        // [scrollV addSubview:itemVC.view];
        [scrollV insertSubview:itemVC.view atIndex:0];
        itemVC.view.frame = CGRectMake(x + i * (minWid + margin), y, minWid, minHei);
        [self.itemVCArray addObject:itemVC];
        [itemVC reloadWithData:nil index:i];
    }
    
}
// 设置手势优先级 缩放优先
- (void)setPanGesturePrior
{
    for (int i = 0; i < self.itemVCArray.count; i++) {
        CardPageItemVC *itemVC = self.itemVCArray[i];
        [itemVC.tableView.panGestureRecognizer requireGestureRecognizerToFail:self.panGesture];
    }
}
// tableView 优先
- (void)setItemsVCPrior
{
    for (int i = 0; i < self.itemVCArray.count; i++) {
        CardPageItemVC *itemVC = self.itemVCArray[i];
        [self.panGesture requireGestureRecognizerToFail:itemVC.tableView.panGestureRecognizer];
    }
}
#pragma mark - Gesture
- (void)panGesture:(UIPanGestureRecognizer *)panGes
{
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.startPoint = [panGes locationInView:self.view];
    } else if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGes locationInView:self.view];
        if (!self.havingSetDrag) {
            CGFloat x_change = point.x - self.startPoint.x;
            CGFloat y_change = point.y - self.startPoint.y;
            if (ABS(y_change) > ABS(x_change)) {
                // 竖直滑动
                if (y_change > 0) {
                    self.dragDirection = DraggingDirectionDown;
                } else {
                    self.dragDirection = DraggingDirectionUp;
                }
            } else {
                // 水平滑动
                self.dragDirection = DraggingDirectionLeftAndRight;
            }
            self.havingSetDrag = YES;
        }
        if (self.cardState == CardStateFullScreen) {
            if (self.dragDirection == DraggingDirectionDown) {
//                CardPageItemVC *itemVC = [self vcWithCurrentIndex];
//                itemVC.tableView.conten
                [self downGesture:panGes];
            } else if (self.dragDirection == DraggingDirectionUp) {
                //panGes.enabled = NO;
                //[panGes setValue:@(UIGestureRecognizerStateFailed) forKey:@"state"];
            }
        } else {
            if (self.dragDirection == DraggingDirectionUp) {
                [self topGesture:panGes];
            } else if (self.dragDirection == DraggingDirectionDown) {
                [self popGesture:panGes];
            }
        }
    } else if (panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateCancelled) {
        self.havingSetDrag = NO;
        //panGes.enabled = YES;
        if (self.cardState == CardStateFullScreen) {
            if (self.dragDirection == DraggingDirectionDown) {
                [self downGesture:panGes];
            }
        } else {
            if (self.dragDirection == DraggingDirectionUp) {
                [self topGesture:panGes];
            } else if (self.dragDirection == DraggingDirectionDown) {
                [self popGesture:panGes];
            }
        }
    }
}
// 向下滑动, 触发退出部分手势时
- (void)popGesture:(UIGestureRecognizer *)panGes
{
    if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGes locationInView:self.view];
        if (self.view.frame.origin.y + point.y - self.startPoint.y < self.startFrame.origin.y) {
            return;
        }
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + point.y - self.startPoint.y, self.view.bounds.size.width, self.view.bounds.size.height);
    } else if (panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateCancelled) {
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
// 向上滑动放大
- (void)topGesture:(UIGestureRecognizer *)panGes
{
    if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGes locationInView:self.view];
        if (point.y > self.startPoint.y) { // 超出底部
            self.panHeight = 0;
            CardPageItemVC *itemVC = (CardPageItemVC *)[self vcWithCurrentIndex];
            itemVC.view.frame = [self frameInDragging];
            self.cardState = CardStateNormal;
        } else if (point.y < self.startPoint.y - self.varHei) { // 超出顶部
            self.panHeight = self.varHei;
            CardPageItemVC *itemVC = (CardPageItemVC *)[self vcWithCurrentIndex];
            itemVC.view.frame = [self frameInDragging];
            self.cardState = CardStateFullScreen;
        } else { // 正常缩放
            self.panHeight = self.startPoint.y - point.y;
            CardPageItemVC *itemVC = (CardPageItemVC *)[self vcWithCurrentIndex];
            itemVC.view.frame = [self frameInDragging];
        }
    } else if (panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateCancelled) {
        panGes.enabled = YES;
        CardPageItemVC *itemVC = (CardPageItemVC *)[self vcWithCurrentIndex];
        itemVC.tableView.contentOffset = CGPointMake(0, 0);
        if (self.panHeight > self.varHei / 2) {
            [UIView animateWithDuration:0.1 animations:^{
                itemVC.view.frame = [self maxFrameWithCurrentIndex];
            } completion:^(BOOL finished) {
                self.cardState = CardStateFullScreen;
            }];
        } else {
            [UIView animateWithDuration:0.1 animations:^{
                itemVC.view.frame = [self minFrameWithCurrentIndex];
            } completion:^(BOOL finished) {
                self.cardState = CardStateNormal;
            }];
        }
    }
}
// 向下滑动缩小
- (void)downGesture:(UIGestureRecognizer *)panGes
{
    if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGes locationInView:self.view];
        if (point.y < self.startPoint.y) { // 超出顶部
            self.panHeight = self.varHei;
            CardPageItemVC *itemVC = (CardPageItemVC *)[self vcWithCurrentIndex];
            itemVC.view.frame = [self frameInDragging];
            self.cardState = CardStateFullScreen;
        } else if (point.y > self.startPoint.y + self.varHei) { // 超出底部
            self.panHeight = 0;
            CardPageItemVC *itemVC = (CardPageItemVC *)[self vcWithCurrentIndex];
            itemVC.view.frame = [self frameInDragging];
            self.cardState = CardStateNormal;
        } else { // 正常缩放
            self.panHeight = self.varHei - (point.y - self.startPoint.y);
            CardPageItemVC *itemVC = (CardPageItemVC *)[self vcWithCurrentIndex];
            itemVC.view.frame = [self frameInDragging];
        }
    } else if (panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateCancelled) {
        panGes.enabled = YES;
        CardPageItemVC *itemVC = (CardPageItemVC *)[self vcWithCurrentIndex];
        itemVC.tableView.contentOffset = CGPointMake(0, 0);
        if (self.panHeight > self.varHei / 2) {
            [UIView animateWithDuration:0.1 animations:^{
                itemVC.view.frame = [self maxFrameWithCurrentIndex];
            } completion:^(BOOL finished) {
                self.cardState = CardStateFullScreen;
            }];
        } else {
            [UIView animateWithDuration:0.1 animations:^{
                itemVC.view.frame = [self minFrameWithCurrentIndex];
            } completion:^(BOOL finished) {
                self.cardState = CardStateNormal;
            }];
        }
    }
}

#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"shouldReceiveTouch");
    if (gestureRecognizer == self.panGesture) {
        if (self.cardState == CardStateFullScreen) {
            self.panTouch = touch;
            //return NO;
        }
    }
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"ShouldBegin");
    if (gestureRecognizer == self.panGesture) {
        if (self.cardState == CardStateFullScreen) {
            if (!self.isTop) {
                return NO;
            }
            CGPoint point1 = [self.panTouch previousLocationInView:self.view];
            CGPoint point2 = [self.panTouch locationInView:self.view];
            if (point2.y - point1.y < 0) {
                return NO;
            }
            
        }
    }
    return YES;
}

#pragma mark - CardPageItemVC Delegate
- (void)itemVC:(CardPageItemVC *)itemVC didChangeState:(BOOL)isTop
{
    NSLog(@"%d", isTop);
    self.isTop = isTop;
}
#pragma mark - CardPageHit Delegate
- (BOOL)needRewriteHitTest
{
//    if (self.cardState == CardStateFullScreen) {
//        return NO;
//    }
//    return YES;
    return NO;
}
- (UIView *)view_hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return nil;
}

#pragma mark - frame changing
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
#pragma mark - scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%lf", scrollView.decelerationRate);
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
    
    // 当前页放在最前面
    UIViewController *currentVC = [self vcWithCurrentIndex];
    [self.scrollView bringSubviewToFront:currentVC.view];
    
    //NSLog(@"第 %ld 页", self.pageIndex);
    if (directionType == PageDirectionNext) {
        if (self.pageIndex == 1 || self.pageIndex == self.count - 1) {
            return;
        }
        CardPageItemVC *vc = self.itemVCArray[[self farthestIndexWithLeft:YES]];
        vc.view.frame = CGRectMake(self.edgeW + (self.pageIndex + 1) * (self.minWid + self.margin), self.minY, self.minWid, self.minHei);
        [vc reloadWithData:nil index:self.pageIndex + 1];
    } else if (directionType == PageDirectionLast) {
        if (self.pageIndex == self.count - 2 || self.pageIndex == 0) {
            return;
        }
        CardPageItemVC *vc = self.itemVCArray[[self farthestIndexWithLeft:NO]];
        vc.view.frame = CGRectMake(self.edgeW + (self.pageIndex - 1) * (self.minWid + self.margin), self.minY, self.minWid, self.minHei);
        [vc reloadWithData:nil index:self.pageIndex - 1];
    }
}
#pragma mark - private
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
- (CGRect)frameInDragging
{
    CGFloat maxW = self.view.bounds.size.width;
    CGFloat maxH = self.view.bounds.size.height;
    CGFloat scale = (1 - self.minScale) * self.panHeight / self.varHei + self.minScale;
    CGRect minFrame = [self minFrameWithCurrentIndex];
    CGFloat x_changed = (scale * maxW - minFrame.size.width) / 2;
    CGFloat y_changed = self.panHeight + (scale * maxH - minFrame.size.height) / 2;
    CGFloat x_final = minFrame.origin.x - x_changed;
    CGFloat y_final = minFrame.origin.y - y_changed;
    CGFloat w_final = scale * maxW;
    CGFloat h_final = scale * maxH;
    return CGRectMake(x_final, y_final, w_final, h_final);
}
- (CGRect)minFrameWithCurrentIndex
{
    return CGRectMake(_edgeW + self.pageIndex * (_minWid + _margin), _minY, _minWid, _minHei);
}
- (CGRect)maxFrameWithCurrentIndex
{
    return CGRectMake(self.scrollView.contentOffset.x, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}
- (UIViewController *)vcWithCurrentIndex
{
    for (int i = 0 ; i < self.itemVCArray.count; i++) {
        CardPageItemVC *itemVC = self.itemVCArray[i];
        if (itemVC.index == self.pageIndex) {
            return itemVC;
        }
    }
    return nil;
}
- (void)setCardState:(CardState)cardState
{
    _cardState = cardState;
    switch (cardState) {
        case CardStateNormal: {
            self.scrollView.scrollEnabled = YES;
//            [self setupPanGesture];
//            [self setPanGesturePrior];
            break;
        }
        case CardStateFullScreen: {
            self.scrollView.scrollEnabled = NO;
//            [self setupPanGesture];
//            [self setItemsVCPrior];
            break;
        }
        default:
            break;
    }
}



#pragma mark - privite func



@end





