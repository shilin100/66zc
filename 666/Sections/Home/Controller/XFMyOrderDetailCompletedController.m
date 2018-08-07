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
    // 日期格式化类
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    // 设置日期格式 为了转换成功
    
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // NSString * -> NSDate *
    NSDate *startDate = [format dateFromString:self.model.start_time];
    NSDate * now = [NSDate date];
    NSTimeInterval timeBetween = [now timeIntervalSinceDate:startDate];
    
    if (timeBetween > 3600*24*90) {
        XFAlertView *  alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"90天前的历史行程轨迹无法查看" sureBtn:@"确定" cancleBtn:nil];
        [alert showAlertView];
        return;

    }

    
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
