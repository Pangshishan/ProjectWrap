//
//  ViewController.m
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/7.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import "ViewController.h"
#import "CardPageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CardPageViewController *vc = [[CardPageViewController alloc] init];
    vc.view.frame = self.view.bounds;
    vc.startFrame = vc.self.view.bounds;
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
}


@end










