//
//  UIView+ZFAddRectangBorder.m
//  ZhiFa
//
//  Created by Exsun on 16/9/2.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "UIView+ZFAddRectangBorder.h"

@implementation UIView (ZFAddRectangBorder)
-(void)ZFAddBorderWithColor:(UIColor *)color Width:(float)width{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}
@end
