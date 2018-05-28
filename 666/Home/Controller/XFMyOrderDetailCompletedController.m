//
//  XFMyOrderDetailCompletedController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/24.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyOrderDetailCompletedController.h"
#import "XFMyOrderModel.h"
#import "XFMyOrderDetailCompletedView.h"
#import "XFMyTripViewController.h"


@interface XFMyOrderDetailCompletedController ()<XFMyOrderDetailCompletedViewDelegate>

@property (nonatomic, strong) XFMyOrderDetailCompletedView *contentView;

@end

@implementation XFMyOrderDetailCompletedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    XFMyOrderDetailCompletedView *contentView = [[XFMyOrderDetailCompletedView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
    [self.view addSubview:contentView];
    self.contentView=contentView;
    contentView.delegate=self;

    self.contentView.model=self.model;
    
}


-(void)XFMyOrderDetailCompletedView:(XFMyOrderDetailCompletedView *)contentView didClickTripBtn:(UIButton *)button
{
     NSLog(@"我的行程");
    XFMyTripViewController *vc = [[XFMyTripViewController alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
