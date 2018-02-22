//
//  ItemViewController.h
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/7.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemViewController;
@protocol ItemViewControllerProtocol <NSObject>

- (void)itemVC:(ItemViewController *)itemVC didChangeState:(BOOL)isTop;

@end

@interface ItemViewController : UIViewController

@property (nonatomic, weak) id<ItemViewControllerProtocol> delegate;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger index;

- (void)reloadWithData:(NSDictionary *)data index:(NSInteger)index;
- (void)frameChanged;

@end
