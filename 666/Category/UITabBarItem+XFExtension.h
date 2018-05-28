//
//  UITabBarItem+XFExtension.h
//  新浪微博项目－2
//
//  Created by xiaofan on 15/11/29.
//  Copyright © 2015年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (XFExtension)
+ (UIBarButtonItem *) itemWithTarget:(id) target action:(SEL)action image:(NSString *)image hightLightedImage:(NSString *)hightLightedImage;

@end
