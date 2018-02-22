//
//  CardPageVCView.m
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/12.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import "CardPageVCView.h"

@implementation CardPageVCView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(view_hitTest:withEvent:)]) {
        if ([self.delegate respondsToSelector:@selector(needRewriteHitTest)]) {
            if ([self.delegate needRewriteHitTest]) {
                return [self.delegate view_hitTest:point withEvent:event];
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

@end
