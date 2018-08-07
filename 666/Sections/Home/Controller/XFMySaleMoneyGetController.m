//
//  XFMySaleMoneyGetController.m
//  666
//
//  Created by xiaofan on 2017/10/21.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMySaleMoneyGetController.h"
#import "XFMySaleMoneyGetView.h"
#import "XFWarnView.h"


@interface XFMySaleMoneyGetController ()<XFMySaleMoneyGetViewDelegate>

@property (nonatomic, strong) XFMySaleMoneyGetView *contentView;

@property (nonatomic, assign) float k_servant;

@end

@implementation XFMySaleMoneyGetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现";
    XFMySaleMoneyGetView *contentView = [[XFMySaleMoneyGetView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64)];
    [self.view addSubview:contentView];
    self.contentView=contentView;
    self.contentView.delegate=self;
    
    if (self.isCash) {
        self.contentView.moneyTF.userInteractionEnabled = NO;
        self.contentView.moneyTF.text = [NSString stringWithFormat:@"%.2f",self.amount];
        self.contentView.yeLabel2.text = [NSString stringWithFormat:@"%.2f 元",self.amount];
        self.contentView.eduLabel2.text = [NSString stringWithFormat:@"%.2f 元",self.amount];
    }else{
        
        self.contentView.moneyTF.userInteractionEnabled = YES;
        
//        self.k_servant=[_totalMoney floatValue]-[_txzMoney floatValue];
//        self.contentView.yeLabel2.text = [NSString stringWithFormat:@"%.2f元",[_totalMoney floatValue]];
//        self.contentView.eduLabel2.text = [NSString stringWithFormat:@"%.2f 元",self.k_servant];
        
        
        //获取账户余额
        [self getMoneyData];
        
    }
}

-(void)getMoneyData
{
    [SVProgressHUD showInfoWithStatus:nil];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/apply_money",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
//        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {

            float a_servant=[responseObject[@"a_servant"] floatValue];
            self.k_servant=[responseObject[@"k_servant"] floatValue];
            self.contentView.yeLabel2.text = [NSString stringWithFormat:@"%.2f 元",a_servant];
            self.contentView.eduLabel2.text = [NSString stringWithFormat:@"%.2f 元",self.k_servant];

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];

}



-(void)XFMySaleMoneyGetView:(XFMySaleMoneyGetView *)contentView didClickCommitBtn:(UIButton *)button
{
    //押金
    if (self.isCash)
    {
        [self submitWithType:@"1" money:[NSString stringWithFormat:@"%f ",self.amount]];
    }
    //佣金
    else
    {
        if(self.contentView.moneyTF.text.length)
        {
            if([self.contentView.moneyTF.text floatValue] < 100)
            {
                [SVProgressHUD showErrorWithStatus:@"低于最低提现额度100元"];
                [SVProgressHUD dismissWithDelay:1.2];
                return;
            }
            
            if([self.contentView.moneyTF.text floatValue] <= self.k_servant)
            {
                [self submitWithType:@"2" money:self.contentView.moneyTF.text];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"超出可提现额度"];
                [SVProgressHUD dismissWithDelay:1.2];
                
            }
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请输入申请金额"];
            [SVProgressHUD dismissWithDelay:1.2];
    
        }
        
    }
}

-(void)submitWithType:(NSString *)type money:(NSString *)money
{
    [SVProgressHUD showInfoWithStatus:nil];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    [params setObject:@"1" forKey:@"user_type"];
    [params setObject:type forKey:@"type"];
    [params setObject:money forKey:@"money"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/upmoney",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseObject***:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            [SVProgressHUD showSuccessWithStatus:@"您的提现申请已提交,系统会在3到5个工作日退还至您指定的账号"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            XFWarnView * view = [XFWarnView new];
            view.titleLabel.text = responseObject[@"info"];
            [view showWithoutImg];

//            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
