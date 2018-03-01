//
//  CardPageVCView.h
//  CardPageDemo
//
//  Created by pangshishan on 2018/2/12.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishCardPageProtocol.h"

@interface CardPageVCView : UIView

@property (nonatomic, weak) id<CardPageVCHitDelegate> delegate;

@end
