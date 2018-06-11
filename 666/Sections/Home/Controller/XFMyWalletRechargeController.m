//
//  XFMyWalletRechargeController.m
//  666
//
//  Created by xiaofan on 2017/10/21.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyWalletRechargeController.h"
#import "XFWXPayReqModel.h"

@interface XFMyWalletRechargeController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (nonatomic, weak) UIButton *selectedPayBtn;

@end

@implementation XFMyWalletRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedPayBtn = self.wxBtn;
    
    self.moneyLbl.text = [NSString stringWithFormat:@"%.2f 元",self.money];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResultHandle:) name:AliPayResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResultHandle:) name:WXPayResultNotification object:nil];

}
- (IBAction)wxBtnClick:(UIButton *)sender {
    if (self.selectedPayBtn == sender) {
        return;
    }else{
        self.selectedPayBtn.selected = NO;
        sender.selected = YES;
        self.selectedPayBtn = sender;
    }
}
- (IBAction)alipayBtnClick:(UIButton *)sender {
    if (self.selectedPayBtn == sender) {
        return;
    }else{
        self.selectedPayBtn.selected = NO;
        sender.selected = YES;
        self.selectedPayBtn = sender;
    }
}
- (IBAction)doRechargeBtnClick {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    int type = self.selectedPayBtn == self.alipayBtn ? 1:2;
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:@(self.money) forKey:@"money"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@1 forKey:@"user_type"];
    [params setObject:@(self.money_type) forKey:@"money_type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/money",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSLog(@"responseObject==%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            if (type == 1) {

                [[AlipaySDK defaultService] payOrder:[NSString stringWithFormat:@"%@",responseObject[@"url"]] fromScheme:@"llzuche" callback:^(NSDictionary *resultDic) {
                     NSLog(@"reslut = %@",resultDic);
                    
                    int resultStatus = [resultDic[@"resultStatus"] intValue];
                    NSString *memo = resultDic[@"memo"];
                    
                    switch (resultStatus) {
                        case 9000:
                            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
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
                    [SVProgressHUD dismissWithDelay:3.0 completion:^{
                        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
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
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error:%@",error);
    }];
}
- (void) alipayResultHandle:(NSNotification *)notification {
    NSLog(@"notification==%@",[notification object]);
    int resultStatus = [[notification object][@"resultStatus"] intValue];
    NSString *memo = [notification object][@"memo"];
    
    switch (resultStatus) {
        case 9000:
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
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
    [SVProgressHUD dismissWithDelay:3.0 completion:^{
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }];
}
- (void) WXPayResultHandle:(NSNotification *)notification {
    NSLog(@"wx_notifi:%@--%d",((PayResp *)notification.object).errStr,((PayResp *)notification.object).errCode);
    switch (((PayResp *)notification.object).errCode) {
        case 0:
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
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
    [SVProgressHUD dismissWithDelay:3.0 completion:^{
         [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayResultNotification object:nil];
}
@end
