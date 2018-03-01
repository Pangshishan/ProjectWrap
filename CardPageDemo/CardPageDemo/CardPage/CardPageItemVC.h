//
//  CardPageItemVC.h
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/7.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishCardPageProtocol.h"

@interface CardPageItemVC : UIViewController

@property (nonatomic, weak) id<WishCardPageProtocol> delegate;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger index;

- (void)reloadWithData:(NSDictionary *)data index:(NSInteger)index;

// 暂时未用到
- (void)frameChanged;

@end
