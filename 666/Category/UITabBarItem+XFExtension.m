//
//  UITabBarItem+XFExtension.m
//  新浪微博项目－2
//
//  Created by xiaofan on 15/11/29.
//  Copyright © 2015年 xiaofan. All rights reserved.
//

#import "UITabBarItem+XFExtension.h"

@implementation UITabBarItem (XFExtension)
+ (UIBarButtonItem *) itemWithTarget:(id) target action:(SEL)action image:(NSString *)image hightLightedImage:(NSString *)hightLightedImage
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightLightedImage] forState:UIControlStateHighlighted];
//    button.size = button.currentImage.size;
    button.size=CGSizeMake(25, 25);
    
    //监听点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
