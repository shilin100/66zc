//
//  XFPreLoginController.m
//  666
//
//  Created by xiaofan on 2017/9/29.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFPreLoginController.h"

@interface XFPreLoginController ()
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@end

@implementation XFPreLoginController
#pragma mark - SYS
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化子控件
    [self setupSubs];
}
#pragma mark - FUNC
/**初始化子控件*/
- (void) setupSubs {
    // 登录按钮
    self.loginBtn.layer.cornerRadius = self.loginBtn.height*0.5;

    // 轮播
    self.cycleImageView.backgroundColor = CLEARCOLOR;
    self.cycleImageView.autoScrollTimeInterval = 2.8;
    self.cycleImageView.bannerImageViewContentMode = UIViewContentModeCenter;
    self.cycleImageView.localizationImageNamesGroup = @[@"dianyi-zi",@"dianer-zi",@"diansan-zi"];
    self.cycleImageView.currentPageDotColor = MAINGREEN;
    self.cycleImageView.pageDotColor = GRAYCOLOR;
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
