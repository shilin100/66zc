//
//  XFMyBreakRulesDetailController.m
//  666
//
//  Created by TDC_MacMini on 2017/11/25.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyBreakRulesDetailController.h"
#import "XFMyBreakRulesDetailView.h"
#import "XFWXPayReqModel.h"
#import "XFCleanScoreController.h"
#import "XFBreakRuleDetailModel.h"
#import "XFBreakRuleModel.h"

@interface XFMyBreakRulesDetailController ()<XFMyBreakRulesDetailViewDelegate>

@property (nonatomic, strong) XFMyBreakRulesDetailView *contentView;
@property (nonatomic, weak) UIButton *selectedPayBtn;

@end

@implementation XFMyBreakRulesDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResultHandle:) name:AliPayResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResultHandle:) name:WXPayResultNotification object:nil];
    
    XFMyBreakRulesDetailView *contentView = [[XFMyBreakRulesDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
    [self.view addSubview:contentView];
    self.contentView=contentView;
    self.contentView.delegate=self;
    self.contentView.model=self.model;
    
    
    self.selectedPayBtn = self.contentView.wxBtn;
    
//    [self getDetail];

}

//-(void)getDetail
//{
//    [SVProgressHUD show];
//    NSMutableDictionary *params = [XFTool baseParams];
//    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
//    [params setObject:model.uid forKey:@"uid"];
//    [params setObject:model.token forKey:@"token"];
//    [params setObject:self.model.breakRule_id forKey:@"tid"];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:[NSString stringWithFormat:@"%@/My/ticket_detail",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SVProgressHUD dismiss];
//        NSLog(@"responseObject***%@",responseObject);
//
//        if ([responseObject[@"status"] intValue] == 1)
//        {
//            XFBreakRuleDetailModel *model = [XFBreakRuleDetailModel mj_objectWithKeyValues:responseObject];
//
//            if([responseObject[@"punish_status"] isEqualToString:@"1"])
//            {
//                //支付
//                self.contentView.model=model;
//            }
//
//            else
//            {
//                //未处理先销分
//                XFCleanScoreController *vc=[[XFCleanScoreController alloc] init];
//                vc.model=model;
//                [self.navigationController pushViewController:vc animated:YES];
//
//            }
//
//
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
//        [SVProgressHUD dismiss];
//        NSLog(@"error***:%@",error);
//        [SVProgressHUD showErrorWithStatus:ServerError];
//    }];
//
//}


- (void)XFMyBreakRulesDetailView:(XFMyBreakRulesDetailView *)contentView didClickWxBtn:(UIButton *)button
{
    if (self.selectedPayBtn == button) {
        return;
    }
    button.selected = YES;
    self.selectedPayBtn.selected = NO;
    self.selectedPayBtn = button;
}
- (void)XFMyBreakRulesDetailView:(XFMyBreakRulesDetailView *)contentView didClickZfbBtn:(UIButton *)button
{
    if (self.selectedPayBtn == button) {
        return;
    }
    button.selected = YES;
    self.selectedPayBtn.selected = NO;
    self.selectedPayBtn = button;
}

- (void)XFMyBreakRulesDetailView:(XFMyBreakRulesDetailView *)contentView didClickCommitBtn:(UIButton *)button
{
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    int type = self.selectedPayBtn == self.contentView.wxBtn ? 2:1;
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:self.model.breakRule_id forKey:@"oid"];
    [params setObject:self.model.pay_money forKey:@"money"];
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/Pay/Index",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseObject***%@",responseObject);
        
        if (type == 1) {
            [[AlipaySDK defaultService] payOrder:[NSString stringWithFormat:@"%@",responseObject[@"url"]] fromScheme:@"llzuche" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
                int resultStatus = [resultDic[@"resultStatus"] intValue];
                NSString *memo = resultDic[@"memo"];
                
                switch (resultStatus) {
                    case 9000:
                        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                        NSLog(@"oid:%@",self.model.breakRule_id);
                        break;
                    case 8000 : case 6001:
                        [SVProgressHUD showInfoWithStatus:memo];
                        break;
                    case 4000 : case 6002:
                        [SVProgressHUD showErrorWithStatus:memo];
                        break;
                        
                    default:
                        break;
                }
                [SVProgressHUD dismissWithDelay:2.0 completion:^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }];
        }else{
            XFWXPayReqModel *model = [XFWXPayReqModel mj_objectWithKeyValues:responseObject[@"config"]];
            if ([model.return_code isEqualToString:@"SUCCESS"]) {
                PayReq *req = [[PayReq alloc] init];
                req.partnerId = model.mch_id;
                req.prepayId = model.prepay_id;
                req.nonceStr = model.nonce_str;
                req.timeStamp = model.timestamp;
                req.package = model.wxpackage;
                req.sign = model.sign;
                
                [WXApi sendReq:req];
                //没安装微信客户端
                if (![WXApi isWXAppInstalled])
                {
                    XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"请先安装微信再进行支付" sureBtn:@"确定" cancleBtn:nil];
                    [alert showAlertView];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error***:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
    
}


- (void) alipayResultHandle:(NSNotification *)notification {
    int resultStatus = [[notification object][@"resultStatus"] intValue];
    NSString *memo = [notification object][@"memo"];
    
    switch (resultStatus) {
        case 9000:
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            NSLog(@"oid:%@",self.model.breakRule_id);
            break;
        case 8000 : case 6001:
            [SVProgressHUD showInfoWithStatus:memo];
            break;
        case 4000 : case 6002:
            [SVProgressHUD showErrorWithStatus:memo];
            break;
            
        default:
            break;
    }
    [SVProgressHUD dismissWithDelay:2.0 completion:^{
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void) WXPayResultHandle:(NSNotification *)notification {
    //    NSLog(@"wx_notifi:%@--%d",((PayResp *)notification.object).errStr,((PayResp *)notification.object).errCode);
    switch (((PayResp *)notification.object).errCode) {
        case 0:
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            NSLog(@"oid:%@",self.model.breakRule_id);
            break;
        case -1:
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
            break;
        case -2:
            [SVProgressHUD showInfoWithStatus:@"支付已取消"];
            break;
        case -3:
            [SVProgressHUD showErrorWithStatus:@"发起支付失败"];
            break;
        case -4:
            [SVProgressHUD showErrorWithStatus:@"授权支付失败"];
            break;
        case -5:
            [SVProgressHUD showErrorWithStatus:@"不支持该支付"];
            break;
            
        default:
            break;
    }
    [SVProgressHUD dismissWithDelay:2.0 completion:^{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayResultNotification object:nil];
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
