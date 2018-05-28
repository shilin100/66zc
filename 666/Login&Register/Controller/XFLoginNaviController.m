//
//  XFLoginNaviController.m
//  666
//
//  Created by xiaofan on 2017/9/29.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFLoginNaviController.h"
#import "XFDoLoginController.h"

@interface XFLoginNaviController ()

@end

@implementation XFLoginNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:XFont(15)}];
    
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

-(void)dealloc{
    NSLog(@"loginNav dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
