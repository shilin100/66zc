//
//  UIControl+XF.h
//  666
//
//  Created by xiaofan on 2017/11/2.
//  Copyright © 2017年 xiaofan. All rights reserved.

//  防止多次点击按钮

#import <UIKit/UIKit.h>
#define defaultInterval .5//默认时间间隔
@interface UIControl (XF)
@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔

@property(nonatomic,assign)BOOL isIgnoreEvent;//YES不允许点击NO允许点击
@end

