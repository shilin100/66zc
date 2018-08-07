//
//  XFMyOrdersDetailController.m
//  666
//
//  Created by TDC_MacMini on 2017/12/2.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyOrdersDetailController.h"
#import "XFMyOrdersDetailView.h"
#import "UITabBarItem+XFExtension.h"
#import "XFMyOrderModel.h"
#import "XFCar_endModel.h"
#import "XFWXPayReqModel.h"
#import "XFUseTicketController.h"
#import "XFUseTicketModel.h"
#import "FBKVOController.h"


@interface XFMyOrdersDetailController ()<XFMyOrdersDetailViewDelegate>

@property (nonatomic, strong) XFMyOrdersDetailView *contentView;
@property (nonatomic, weak) UIButton *selectedPayBtn;
@property (nonatomic, strong) XFUseTicketModel *ticketModel;
@property (nonatomic, assign) float payMoney;


@end

@implementation XFMyOrdersDetailController
{
    FBKVOController *_KVOController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    self.navigationItem.leftBarButtonItem = [UITabBarItem itemWithTarget:self action:@selector(back) image:@"fanhuijianbaise" hightLightedImage:@""];
    
    XFMyOrdersDetailView *contentView = [[XFMyOrdersDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
    [self.view addSubview:contentView];
    self.contentView=contentView;
    contentView.delegate=self;
    
    self.selectedPayBtn = self.contentView.wxBtn;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResultHandle:) name:AliPayResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResultHandle:) name:WXPayResultNotification object:nil];
    [self setupDatas];
    
    _KVOController = [FBKVOController controllerWithObserver:self];
    
    // handle clock change, including initial value
    [_KVOController observe:self.contentView.realPayMoLabel2 keyPath:@"text" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSString * str = self.contentView.realPayMoLabel2.text;
        int k = (int)[str integerValue]/10;
        self.contentView.creditsLabel2.text = [NSString stringWithFormat:@"积分+%d",k];
    }];

}


-(void)back
{
    if([self.typeStr isEqualToString:@"endPay"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) setupDatas {
    
    if([self.typeStr isEqualToString:@"endPay"])
    {
        self.contentView.totalMoneyLabel2.text = [NSString stringWithFormat:@"%@元",self.endModel.sum_cost];
        self.contentView.cphLabel2.text = self.endModel.code.length>0? self.endModel.code:@"无";
        self.contentView.startPoLabel2.text = self.endModel.start_address;
        self.contentView.endPoLabel2.text = self.endModel.end_address;
        self.contentView.totalTimeLabel2.text = [NSString stringWithFormat:@"%@分钟",self.endModel.sum_time];
        self.contentView.totalMileLabel2.text = [NSString stringWithFormat:@"%@km",self.endModel.longMiles];
        self.contentView.bxMoLabel2.text = self.endModel.starting.length>0?[NSString stringWithFormat:@"%@元",self.endModel.starting]:@"0元";
        self.contentView.mileMoLabel2.text = [NSString stringWithFormat:@"%@元",self.endModel.cost];
        self.contentView.stopMoLabel2.text = [NSString stringWithFormat:@"%@元",self.endModel.time_cost];
        self.contentView.realPayMoLabel2.text = [NSString stringWithFormat:@"%@元",self.endModel.sum_cost];
        self.contentView.startTimeLabel2.text = self.endModel.start_time;
        self.contentView.endTimeLabel2.text = self.endModel.end_time;

    }
    else
    {
        self.contentView.totalMoneyLabel2.text = [NSString stringWithFormat:@"%.2f元",self.model.money];
        self.contentView.cphLabel2.text = self.model.car_number.length>0?self.model.car_number:@"无";
        self.contentView.startPoLabel2.text = self.model.start_address;
        self.contentView.endPoLabel2.text = self.model.end_address;
        self.contentView.totalTimeLabel2.text = [NSString stringWithFormat:@"%@",self.model.sum_time];
        self.contentView.totalMileLabel2.text = [NSString stringWithFormat:@"%.2fkm",self.model.sumMiles];
        self.contentView.bxMoLabel2.text = self.model.starting.length>0?[NSString stringWithFormat:@"%@元",self.model.starting]:@"0元";
        self.contentView.mileMoLabel2.text = [NSString stringWithFormat:@"%.2f元",self.model.cost];
        self.contentView.stopMoLabel2.text = [NSString stringWithFormat:@"%.2f元",self.model.stop_cost];
        self.contentView.realPayMoLabel2.text = [NSString stringWithFormat:@"%.2f元",self.model.money];
//        self.contentView.ticketLabel2.text = [NSString stringWithFormat:@"-%@元",self.model.coupon];
        self.contentView.startTimeLabel2.text = self.model.start_time;
        self.contentView.endTimeLabel2.text = self.model.end_time;

    }
    
}

-(void)XFMyOrdersDetailView:(XFMyOrdersDetailView *)contentView didClickTicketBtn:(UIButton *)button
{
    XFUseTicketController *vc = [[XFUseTicketController alloc] init];
    if([self.typeStr isEqualToString:@"endPay"])
    {
        vc.orderMoney = [self.endModel.sum_cost floatValue];
    }
    else
    {
        vc.orderMoney = self.model.money;
    }
    
    vc.ticketBlock = ^(XFUseTicketModel *ticketModel) {
        if (ticketModel.money > 0) {
            self.contentView.ticketLabel2.text = [NSString stringWithFormat:@"-%.2f元",ticketModel.money];
            if([self.typeStr isEqualToString:@"endPay"])
            {
                float sumMoney=[self.endModel.sum_cost floatValue];
                float ticketMoney=ticketModel.money;
                self.contentView.realPayMoLabel2.text = [NSString stringWithFormat:@"%.2f元",sumMoney-ticketMoney];
            }
            else
            {
                float sumMoney=self.model.money;
                float ticketMoney=ticketModel.money;
                self.contentView.realPayMoLabel2.text = [NSString stringWithFormat:@"%.2f元",sumMoney-ticketMoney];
            }
            self.ticketModel = ticketModel;
            
        }else{
            
            if([self.typeStr isEqualToString:@"endPay"])
            {
                float sumMoney=[self.endModel.sum_cost floatValue];
                self.contentView.realPayMoLabel2.text = [NSString stringWithFormat:@"%.2f元",sumMoney];
            }
            else
            {
                float sumMoney=self.model.money;
                self.contentView.realPayMoLabel2.text = [NSString stringWithFormat:@"%.2f元",sumMoney];
            }
            
            self.contentView.ticketLabel2.text = nil;
            self.ticketModel = nil;
        }
    };
    if (self.contentView.ticketLabel2.text.length > 0) {
        vc.isUnuse = NO;
    }else{
        vc.isUnuse = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)XFMyOrdersDetailView:(XFMyOrdersDetailView *)contentView didClickWxBtn:(UIButton *)button
{
    if (self.selectedPayBtn == button) {
        return;
    }
    button.selected = YES;
    self.selectedPayBtn.selected = NO;
    self.selectedPayBtn = button;
}

-(void)XFMyOrdersDetailView:(XFMyOrdersDetailView *)contentView didClickZfbBtn:(UIButton *)button
{
    if (self.selectedPayBtn == button) {
        return;
    }
    button.selected = YES;
    self.selectedPayBtn.selected = NO;
    self.selectedPayBtn = button;
}

-(void)XFMyOrdersDetailView:(XFMyOrdersDetailView *)contentView didClickPayBtn:(UIButton *)button
{
    NSMutableDictionary *params = [XFTool baseParams];
    int type = self.selectedPayBtn == self.contentView.wxBtn ? 2:1;
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:@(type) forKey:@"type"];
    
    if([self.typeStr isEqualToString:@"endPay"])
    {
        [params setObject:self.endModel.order_id forKey:@"oid"];
    }
    else
    {
        [params setObject:self.model.order_id forKey:@"oid"];
    }
    
    if (self.ticketModel) {
        
        if([self.typeStr isEqualToString:@"endPay"])
        {
            _payMoney=[self.endModel.sum_cost floatValue]-self.ticketModel.money;
        }
        else
        {
            _payMoney=self.model.money-self.ticketModel.money;
            
        }
        [params setObject:@(_payMoney) forKey:@"money"];
        [params setObject:@1 forKey:@"iscoupon"]; // iscoupon :是否使用优惠券 1:使用 2:不使用
        [params setObject:@(self.ticketModel.money) forKey:@"coupon"];
        [params setObject:self.ticketModel.ticket_id forKey:@"coupon_id"];
    }else{
        if([self.typeStr isEqualToString:@"endPay"])
        {
            _payMoney=[self.endModel.sum_cost floatValue];
        }
        else
        {
            _payMoney=self.model.money;
            
        }
        [params setObject:@(_payMoney) forKey:@"money"];
        [params setObject:@2 forKey:@"iscoupon"];
    }
    
    NSLog(@"params===%@",params);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/Pay/Index",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject***%@",responseObject);
        
        if (type == 1) {
            [[AlipaySDK defaultService] payOrder:[NSString stringWithFormat:@"%@",responseObject[@"url"]] fromScheme:@"llzuche" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
                int resultStatus = [resultDic[@"resultStatus"] intValue];
                NSString *memo = resultDic[@"memo"];
                
                switch (resultStatus) {
                    case 9000:
                    {
                        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                        //            NSLog(@"oid:%@",self.model.order_id);
                        [SVProgressHUD dismissWithDelay:2.0 completion:^{
                            
                            if([self.typeStr isEqualToString:@"endPay"])
                            {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                            else
                            {
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                        //调用佣金获取接口
                        [self getYJData];
                        
                    }
                        
                        break;
                    case 8000 : case 6001:
                        [SVProgressHUD showErrorWithStatus:memo];
                        break;
                    case 4000 : case 6002:
                        [SVProgressHUD showErrorWithStatus:memo];
                        break;
                        
                    default:
                        break;
                }
                
                
                
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
        NSLog(@"error***:%@",error);
    }];
    
}

- (void) alipayResultHandle:(NSNotification *)notification {
    int resultStatus = [[notification object][@"resultStatus"] intValue];
    NSString *memo = [notification object][@"memo"];
    
    switch (resultStatus) {
        case 9000:
            {
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                //            NSLog(@"oid:%@",self.model.order_id);
                [SVProgressHUD dismissWithDelay:2.0 completion:^{
                    
                    if([self.typeStr isEqualToString:@"endPay"])
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                //调用佣金获取接口
                [self getYJData];
                
            }
            
            break;
        case 8000 : case 6001:
            [SVProgressHUD showErrorWithStatus:memo];
            break;
        case 4000 : case 6002:
            [SVProgressHUD showErrorWithStatus:memo];
            break;
            
        default:
            break;
    }
   
    
}

- (void) WXPayResultHandle:(NSNotification *)notification {
    //    NSLog(@"wx_notifi:%@--%d",((PayResp *)notification.object).errStr,((PayResp *)notification.object).errCode);
    switch (((PayResp *)notification.object).errCode) {
        case 0:
            {
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                //            NSLog(@"oid:%@",self.model.order_id);
                [SVProgressHUD dismissWithDelay:2.0 completion:^{
                    
                    if([self.typeStr isEqualToString:@"endPay"])
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }];
                
                //调用佣金获取接口
                [self getYJData];
                
            }
            
            break;
        case -1:
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
            break;
        case -2:
            [SVProgressHUD showErrorWithStatus:@"支付已取消"];
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
    
}

-(void)getYJData
{
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:@(_payMoney) forKey:@"money"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/My/add_commission",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"commission:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            NSLog(@"commission=%d,add_commission=%d",[responseObject[@"commission"] intValue],[responseObject[@"add_commission"] intValue]);
        }
        else
        {
            NSLog(@"info===%@",responseObject[@"info"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error);
//        [SVProgressHUD showErrorWithStatus:ServerError];
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
