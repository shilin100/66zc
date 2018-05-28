//
//  XFGiveCarServiceDetailController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/27.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFGiveCarServiceDetailController.h"
#import "XFGiveCarServiceDetailView.h"

@interface XFGiveCarServiceDetailController ()

@property (nonatomic, strong) XFGiveCarServiceDetailView *contentView;

@end

@implementation XFGiveCarServiceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    XFGiveCarServiceDetailView *contentView = [[XFGiveCarServiceDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
    [self.view addSubview:contentView];
    self.contentView=contentView;
    self.contentView.model=self.model;
    
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
