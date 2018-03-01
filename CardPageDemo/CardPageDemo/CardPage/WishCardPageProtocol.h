//
//  WishCardPageProtocol.h
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/22.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CardPageItemVC;
@protocol WishCardPageProtocol <NSObject>

- (void)itemVC:(CardPageItemVC *)itemVC didChangeState:(BOOL)isTop;

@end

@protocol CardPageVCHitDelegate <NSObject>

- (BOOL)needRewriteHitTest;
- (UIView *)view_hitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end






