//
//  ItemViewController.h
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/7.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

- (void)reloadWithData:(NSDictionary *)data index:(NSInteger)index;

@end
