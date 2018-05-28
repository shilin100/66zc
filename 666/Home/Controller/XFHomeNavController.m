//
//  XFHomeNavController.m
//  666
//
//  Created by xiaofan on 2017/9/30.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFHomeNavController.h"
#import "XFHomeController.h"
#import "UITabBarItem+XFExtension.h"

@interface XFHomeNavController ()

@end

@implementation XFHomeNavController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏样式
    [self.navigationBar setBackgroundImage:IMAGENAME(@"navbg") forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITECOLOR,NSFontAttributeName:XFont(15)}];
    
    // 隐藏nav底部横线
    [self.navigationBar setShadowImage:[UIImage new]];
//    self.navigationBar.translucent=YES;
    
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count > 1) {
        //将按钮设置为leftBarButtonItem(左)
        viewController.navigationItem.leftBarButtonItem = [UITabBarItem itemWithTarget:self action:@selector(back) image:@"fanhuijianbaise" hightLightedImage:@""];
    }
}
- (void) back
{
    [self popViewControllerAnimated:YES];
}
-(void)dealloc{
    NSLog(@"homeNav dealloc");
}
@end
