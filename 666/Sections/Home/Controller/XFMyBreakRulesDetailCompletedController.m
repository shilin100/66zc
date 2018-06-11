//
//  XFMyBreakRulesDetailCompletedController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyBreakRulesDetailCompletedController.h"
#import "XFMyBreakRulesDetailCompletedView.h"
#import "XFBreakRuleModel.h"
#import "XFBreakRuleDetailModel.h"

@interface XFMyBreakRulesDetailCompletedController ()

@property (nonatomic, strong) XFMyBreakRulesDetailCompletedView *contentView;

@end

@implementation XFMyBreakRulesDetailCompletedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    XFMyBreakRulesDetailCompletedView *contentView = [[XFMyBreakRulesDetailCompletedView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
    [self.view addSubview:contentView];
    self.contentView=contentView;
    self.contentView.model=self.model;
    
//    [self getDetail];
    
}

//-(void)getDetail
//{
//    NSMutableDictionary *params = [XFTool baseParams];
//    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
//    [params setObject:model.uid forKey:@"uid"];
//    [params setObject:model.token forKey:@"token"];
//    [params setObject:self.model.order_number forKey:@"tid"];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:[NSString stringWithFormat:@"%@/My/ticket_detail",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSLog(@"responseObject***%@",responseObject);
//
//        if ([responseObject[@"status"] intValue] == 1)
//        {
//            XFBreakRuleDetailModel *model = [XFBreakRuleDetailModel mj_objectWithKeyValues:responseObject];
//
//            self.contentView.model=model;
//        }
//
//        else
//        {
//            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
//            [SVProgressHUD dismissWithDelay:1.2];
//        }
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error***:%@",error);
//    }];
//
//}



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
