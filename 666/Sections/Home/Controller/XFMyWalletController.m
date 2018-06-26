//
//  XFMyWalletController.m
//  666
//
//  Created by xiaofan on 2017/10/14.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMyWalletController.h"
#import "XFMyWalletRechargeController.h"
#import "XFScoreDetailController.h"
#import "XFMyWalletModel.h"
#import "XFChooseView.h"
#import "XFMySaleMoneyGetController.h"
#import "XFRefundCashViewController.h"

@interface XFMyWalletController ()
@property (nonatomic, weak) UILabel *cashLbl;
@property (nonatomic, weak) UILabel *earnLbl;
@property (nonatomic, strong) XFMyWalletModel *walletModel;

@property (nonatomic, strong) XFButton *cashBtn;
@property (nonatomic, strong) XFButton *spreadBtn;
@property (nonatomic, strong) XFButton *rechargeBtn;


@end

@implementation XFMyWalletController
#pragma mark - SYS
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITECOLOR;
    
    self.navigationItem.title = @"我的钱包";
    
    [self setupSubs];
    
}
- (void) getData {
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *info = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:info.uid forKey:@"uid"];
    [params setObject:info.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/get_cost",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"responseObject===%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            self.walletModel = [XFMyWalletModel mj_objectWithKeyValues:responseObject];
            self.cashLbl.text = [NSString stringWithFormat:@"¥ %@",self.walletModel.money];
            self.earnLbl.text = [NSString stringWithFormat:@"¥ %@",self.walletModel.servant];
            
            if([self.walletModel.cash_type isEqualToString:@"0"])
            {
               //未充值
                [self setNoDisplayView];
            }
            else if ([self.walletModel.cash_type isEqualToString:@"1"])
            {
                //抵押金
                [self setLowDisplayView];
            }
            else if ([self.walletModel.cash_type isEqualToString:@"2"])
            {
                //高押金
                [self setHeightDisplayView];
            }
            else if ([self.walletModel.cash_type isEqualToString:@"3"])
            {
                //提交了提现申请
                [self setHeightDisplayView];
            }
            else
            {
                //
            }
     
            
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"<<:%@",error);
    }];
}

-(void)setNoDisplayView
{
    _cashBtn.hidden=NO;
    _spreadBtn.hidden=NO;
    _rechargeBtn.hidden=NO;
    
    _cashBtn.backgroundColor = WHITECOLOR;
    _cashBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
    [_cashBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    
    _spreadBtn.backgroundColor = WHITECOLOR;
    _spreadBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
    [_spreadBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    
    _rechargeBtn.backgroundColor = MAINGREEN;
    [_rechargeBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    [self.view setNeedsLayout];
}

-(void)setLowDisplayView
{
    _rechargeBtn.hidden=YES;
    _cashBtn.hidden=NO;
    _spreadBtn.hidden=NO;
    
    _cashBtn.backgroundColor = WHITECOLOR;
    _cashBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
    [_cashBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    _cashBtn.sd_layout
    .bottomSpaceToView(self.view, 250*SCALE_HEIGHT)
    .leftSpaceToView(self.view, 50*SCALE_WIDTH)
    .rightSpaceToView(self.view, 50*SCALE_WIDTH)
    .heightIs(80*SCALE_HEIGHT);
    
     _spreadBtn.backgroundColor = MAINGREEN;
    _spreadBtn.layer.borderColor =WHITECOLOR.CGColor;
    [_spreadBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    _spreadBtn.sd_layout
    .bottomSpaceToView(_cashBtn, 30*SCALE_HEIGHT)
    .leftSpaceToView(self.view, 50*SCALE_WIDTH)
    .rightSpaceToView(self.view, 50*SCALE_WIDTH)
    .heightIs(80*SCALE_HEIGHT);
    
    [self.view setNeedsLayout];
    
}

-(void)setHeightDisplayView
{
    _rechargeBtn.hidden=YES;
    _spreadBtn.hidden=YES;
    _cashBtn.hidden=NO;
    _cashBtn.backgroundColor = MAINGREEN;
    _cashBtn.layer.borderColor =WHITECOLOR.CGColor;
    [_cashBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    _cashBtn.sd_layout
    .bottomSpaceToView(self.view, 250*SCALE_HEIGHT)
    .leftSpaceToView(self.view, 50*SCALE_WIDTH)
    .rightSpaceToView(self.view, 50*SCALE_WIDTH)
    .heightIs(80*SCALE_HEIGHT);
    [self.view setNeedsLayout];
}


- (void) setupSubs {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGENAME(@"mingxi") style:UIBarButtonItemStyleDone target:self action:@selector(detailitemClick)];
    UIImageView *content = [[UIImageView alloc] init];
    content.image = IMAGENAME(@"qian-beijing");
    content.contentMode = UIViewContentModeScaleAspectFill;
    content.clipsToBounds = YES;
    [self.view addSubview:content];
    
    content.sd_layout
    .topSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .heightIs(475*SCALE_HEIGHT)
    .rightEqualToView(self.view);
    
    UIImageView *coin = [[UIImageView alloc] init];
    coin.image = IMAGENAME(@"jinbi");
    [content addSubview:coin];
    coin.sd_layout
    .topSpaceToView(content, 70*SCALE_HEIGHT)
    .centerXEqualToView(content)
    .heightIs(142*SCALE_HEIGHT)
    .widthEqualToHeight();
    
    UILabel *cashTitleLbl = [[UILabel alloc] init];
    cashTitleLbl.font = XFont(13);
    cashTitleLbl.textColor = HEXCOLOR(@"#999999");
    cashTitleLbl.text = @"押金";
    cashTitleLbl.textAlignment = NSTextAlignmentCenter;
    [content addSubview:cashTitleLbl];
    cashTitleLbl.sd_layout
    .topSpaceToView(coin, 72*SCALE_HEIGHT)
    .leftSpaceToView(content, 0)
    .heightIs(25*SCALE_HEIGHT)
    .widthIs(SCREENW*0.5);
    
    UILabel *earnTitleLbl = [[UILabel alloc] init];
    earnTitleLbl.font = XFont(13);
    earnTitleLbl.textColor = HEXCOLOR(@"#999999");
    earnTitleLbl.text = @"佣金";
    earnTitleLbl.textAlignment = NSTextAlignmentCenter;
    [content addSubview:earnTitleLbl];
    earnTitleLbl.sd_layout
    .topSpaceToView(coin, 72*SCALE_HEIGHT)
    .leftSpaceToView(cashTitleLbl, 0)
    .heightIs(25*SCALE_HEIGHT)
    .widthIs(SCREENW*0.5);
    
    UILabel *cashLbl = [[UILabel alloc] init];
    cashLbl.font = XFont(23);
    cashLbl.textColor = HEXCOLOR(@"333333");
    cashLbl.textAlignment = NSTextAlignmentCenter;
    cashLbl.text = @"¥ 0";
    [content addSubview:cashLbl];
    self.cashLbl = cashLbl;
    cashLbl.sd_layout
    .topSpaceToView(cashTitleLbl, 30*SCALE_HEIGHT)
    .leftEqualToView(content)
    .heightIs(45*SCALE_HEIGHT)
    .widthRatioToView(cashTitleLbl, 1.0);
    
    UILabel *earnhLbl = [[UILabel alloc] init];
    earnhLbl.font = XFont(23);
    earnhLbl.textColor = HEXCOLOR(@"333333");
    earnhLbl.textAlignment = NSTextAlignmentCenter;
    earnhLbl.text = @"¥ 0";
    [content addSubview:earnhLbl];
    self.earnLbl = earnhLbl;
    earnhLbl.sd_layout
    .topSpaceToView(cashTitleLbl, 30*SCALE_HEIGHT)
    .rightEqualToView(content)
    .heightIs(45*SCALE_HEIGHT)
    .widthRatioToView(cashTitleLbl, 1.0);
    
    _cashBtn = [[XFButton alloc] init];
    _cashBtn.hidden=YES;
    _cashBtn.layer.cornerRadius = 40*SCALE_HEIGHT;
    _cashBtn.clipsToBounds = YES;
    _cashBtn.layer.borderWidth = 1;
    _cashBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
    _cashBtn.titleLabel.font = XFont(15);
    [_cashBtn setTitle:@"提现" forState:UIControlStateNormal];
    [_cashBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    [self.view addSubview:_cashBtn];
    [_cashBtn addTarget:self action:@selector(cashBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _cashBtn.sd_layout
    .bottomSpaceToView(self.view, 140*SCALE_HEIGHT)
    .leftSpaceToView(self.view, 50*SCALE_WIDTH)
    .rightSpaceToView(self.view, 50*SCALE_WIDTH)
    .heightIs(80*SCALE_HEIGHT);
    
    _spreadBtn = [[XFButton alloc] init];
    _spreadBtn.hidden=YES;
    _spreadBtn.layer.cornerRadius = 40*SCALE_HEIGHT;
    _spreadBtn.clipsToBounds = YES;
    _spreadBtn.layer.borderWidth = 1;
    _spreadBtn.layer.borderColor = HEXCOLOR(@"#999999").CGColor;
    _spreadBtn.titleLabel.font = XFont(15);
    [_spreadBtn setTitle:@"补差价" forState:UIControlStateNormal];
    [_spreadBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    [self.view addSubview:_spreadBtn];
    [_spreadBtn addTarget:self action:@selector(spreadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _spreadBtn.sd_layout
    .bottomSpaceToView(_cashBtn, 30*SCALE_HEIGHT)
    .leftSpaceToView(self.view, 50*SCALE_WIDTH)
    .rightSpaceToView(self.view, 50*SCALE_WIDTH)
    .heightIs(80*SCALE_HEIGHT);
    
    _rechargeBtn = [[XFButton alloc] init];
    _rechargeBtn.hidden=YES;
    _rechargeBtn.layer.cornerRadius = 40*SCALE_HEIGHT;
    _rechargeBtn.clipsToBounds = YES;
    _rechargeBtn.titleLabel.font = XFont(15);
    _rechargeBtn.backgroundColor = MAINGREEN;
    [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [_rechargeBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [_rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rechargeBtn];
    _rechargeBtn.sd_layout
    .bottomSpaceToView(_spreadBtn, 30*SCALE_HEIGHT)
    .leftSpaceToView(self.view, 50*SCALE_WIDTH)
    .rightSpaceToView(self.view, 50*SCALE_WIDTH)
    .heightIs(80*SCALE_HEIGHT);
    
}
- (void) detailitemClick {
    XFScoreDetailController *vc = [[XFScoreDetailController alloc] init];
    vc.indentifer = @"wallet";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) rechargeBtnClick {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:user.uid forKey:@"uid"];
    [params setObject:user.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/User/code"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@">>%@",responseObject);
        [hud hideAnimated:YES afterDelay:0.2];
        
        if ([responseObject[@"status"] intValue] == 1) {
            if ([responseObject[@"user_state"] intValue] == 0 || [responseObject[@"user_state"] intValue] == 1) {
                XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您还没有通过审核认证，暂时不能充值" sureBtn:@"确定" cancleBtn:nil];
                [alert showAlertView];
                return;
            }else{
                if ([self.walletModel.cash_type isEqualToString:@"0"]) {
                    [self showChargeView];
                }else if([self.walletModel.cash_type isEqualToString:@"3"]){
                    XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您已提交提现申请，不能充值押金" sureBtn:@"确定" cancleBtn:nil];
                    [alert showAlertView];
                }else if([self.walletModel.cash_type isEqualToString:@"2"]){
                    XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您已经是尊贵的高押金用户啦" sureBtn:@"确定" cancleBtn:nil];
                    [alert showAlertView];
                }else{
                    XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您已经缴纳过押金了，如需成为高押金用户可以选择补差价" sureBtn:@"确定" cancleBtn:nil];
                    [alert showAlertView];
                }
            }
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES afterDelay:0.2];
        NSLog(@"error:%@",error);
    }];
}
- (void) showChargeView {
    XFChooseView *view = [[XFChooseView alloc] initWithTopTitles:@[@"高押金",@"高押金可以使用所有车辆"] bottomTitles:@[@"低押金",@"低押金只能使用低押金车辆"]];
    view.topBlock = ^{
        XFMyWalletRechargeController *vc = [[XFMyWalletRechargeController alloc] init];
        vc.money = [self.walletModel.up floatValue];
        vc.money_type = 1;
        vc.navigationItem.title = @"高押金充值";
        [self.navigationController pushViewController:vc animated:YES];
    };
    view.bottomBlock = ^{
        XFMyWalletRechargeController *vc = [[XFMyWalletRechargeController alloc] init];
        vc.money = [self.walletModel.low floatValue];
        vc.money_type = 1;
        vc.navigationItem.title = @"低押金充值";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [view show];
}
- (void) spreadBtnClick {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:user.uid forKey:@"uid"];
    [params setObject:user.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/User/code"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES afterDelay:0.2];

         if ([responseObject[@"status"] intValue] == 1) {
         if ([responseObject[@"user_state"] intValue] == 0 || [responseObject[@"user_state"] intValue] == 1) {
             XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您还没有通过审核认证，暂时不能充值" sureBtn:@"确定" cancleBtn:nil];
             [alert showAlertView];
             return;
         }else{
             if ([self.walletModel.cash_type isEqualToString:@"0"]) {
                 XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您还未缴纳过押金，不能补差价" sureBtn:@"确定" cancleBtn:nil];
                 [alert showAlertView];
         }else if ([self.walletModel.cash_type isEqualToString:@"1"]){
             XFMyWalletRechargeController *vc = [[XFMyWalletRechargeController alloc] init];
             vc.money = [self.walletModel.up floatValue] - [self.walletModel.low floatValue];
             vc.navigationItem.title = @"补差价";
             vc.money_type = 2;
             [self.navigationController pushViewController:vc animated:YES];
         }else{
             XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您已经缴纳了高押金，不需要补差价" sureBtn:@"确定" cancleBtn:nil];
             [alert showAlertView];
         }
    }
         }else{
         
         }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES afterDelay:0.2];
        NSLog(@"error:%@",error);
    }];
}
- (void) cashBtnClick {
    XFChooseView *view = [[XFChooseView alloc] initWithTopTitles:@[@"退押金",@"您是押金的老用户,是否要退?"] bottomTitles:@[@"提佣金",@"提现已获得的佣金"]];
    view.topBlock = ^{
        if ([self.walletModel.cash_type isEqualToString:@"0"]) {
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"您还没有缴纳押金" sureBtn:@"确定" cancleBtn:nil];
            [alert showAlertView];
        }
        else if ([self.walletModel.cash_type isEqualToString:@"3"])
        {
            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"有提现申请正在审核中不能重复提现" sureBtn:@"确定" cancleBtn:nil];
            [alert showAlertView];
        }
        else{
//            XFMySaleMoneyGetController *vc = [[XFMySaleMoneyGetController alloc] init];
//            vc.isCash = YES;
//            vc.amount = [self.walletModel.money floatValue];
//            [self.navigationController pushViewController:vc animated:YES];
            
            
            XFRefundCashViewController *vc = [[XFRefundCashViewController alloc] init];
            vc.amount = [self.walletModel.money floatValue];
            [self.navigationController pushViewController:vc animated:YES];

        }
    };
    view.bottomBlock = ^{
//        if ([self.walletModel.servant floatValue] < 100.0) {
//            XFAlertView *alert = [[XFAlertView alloc] initWithTitle:@"提示" message:@"佣金满100元才能提现" sureBtn:@"确定" cancleBtn:nil];
//            [alert showAlertView];
//        }else{
            XFMySaleMoneyGetController *vc = [[XFMySaleMoneyGetController alloc] init];
            vc.isCash = NO;
            [self.navigationController pushViewController:vc animated:YES];
//        }
    };
    [view show];
}
@end
