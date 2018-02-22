//
//  CardPageVCView.h
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/12.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardPageVCHitDelegate <NSObject>

- (BOOL)needRewriteHitTest;
- (UIView *)view_hitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end

@interface CardPageVCView : UIView

@property (nonatomic, weak) id<CardPageVCHitDelegate> delegate;

@end
