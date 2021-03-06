//
//  XFMySaleController.m
//  666
//
//  Created by xiaofan on 2017/10/17.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMySaleController.h"
#import "XFMyInviteController.h"
#import "XFMyScoreController.h"
#import "XFMySaleMoneyController.h"
#import "XFMySaleFriendController.h"
#import "XFMySaleTicketController.h"
#import "XFSignInVC.h"
#import "XFWarnView.h"
#import "XFQRCodePopView.h"
#import "XFRankViewController.h"
#import "XFMySaleTicketController.h"


@interface XFMySaleController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UILabel *scoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *ticketLbl;
@property (weak, nonatomic) IBOutlet UILabel *friendLbl;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@property (nonatomic, strong) NSString *ytxStr;
@property (nonatomic, strong) NSString *txzStr;
@property (nonatomic, strong) NSString *moneyStr;



@end

@implementation XFMySaleController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getfxData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    
    
    UIImage *rightImage = [[UIImage imageNamed:@"qrcode_navigationItem"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(qrcodeAction)];

    
    self.inviteBtn.layer.cornerRadius = self.inviteBtn.height * 0.5;
    self.inviteBtn.clipsToBounds = YES;

}

-(void)getfxData
{
    [SVProgressHUD showInfoWithStatus:nil];
    NSMutableDictionary *params = [XFTool baseParams];
    XFLoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:LoginModel_Doc_path];
    [params setObject:model.uid forKey:@"uid"];
    [params setObject:model.token forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/My/my_income",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        if ([responseObject[@"status"] intValue] == 1) {
            
            _moneyStr=responseObject[@"income"];
            NSString *couponStr=responseObject[@"signtimes"];
            NSString *memberStr=responseObject[@"num"];
            _ytxStr=responseObject[@"pull"];
            _txzStr=responseObject[@"pull_now"];
//            NSString *inviteNumStr=responseObject[@"number"];
            
            _moneyLbl.text=[NSString stringWithFormat:@"%.2f",[_moneyStr floatValue]];
            _ticketLbl.text=couponStr;
            _friendLbl.text=memberStr;
            _scoreLbl.text=responseObject[@"integral"];

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:ServerError];
    }];
}

- (void)qrcodeAction{
//    NSMutableDictionary *params = [XFTool getBaseRequestParams];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:[NSString stringWithFormat:@"%@/User/qrcode",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SVProgressHUD dismiss];
//        NSLog(@"success:%@",responseObject);
//        if ([responseObject[@"status"] intValue] == 1) {
//
//
//        }
//        else
//        {
//            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
//            [SVProgressHUD dismissWithDelay:1.2];
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:ServerError];
//        [SVProgressHUD dismissWithDelay:1.2];
//
//    }];

    XFQRCodePopView * pop = [[XFQRCodePopView alloc]initQRCodePopView];
    [pop show];
}

- (IBAction)rankBtnAction:(id)sender {
    
    XFRankViewController * vc = [XFRankViewController new];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)myTicketsAction:(id)sender {
    XFMySaleTicketController * vc = [XFMySaleTicketController new];
    [self.navigationController pushViewController:vc animated:YES];

}


- (IBAction)moneyBtnClick {
    XFMySaleMoneyController *vc = [[XFMySaleMoneyController alloc] init];
    vc.totalMoney=_moneyStr;
    vc.ytxMoney=_ytxStr;
    vc.txzMoney=_txzStr;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)scoreBtnClick {
//    XFMyScoreController *vc = [[XFMyScoreController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    XFWarnView * warnView = [XFWarnView new];
    warnView.titleLabel.text = @"积分系统暂未开放";
    [warnView show];
}
- (IBAction)ticketBtnClick {

    XFSignInVC *vc = [[XFSignInVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)friendBtnClick {
    XFMySaleFriendController *vc = [[XFMySaleFriendController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)inviteBtnClick {
    XFMyInviteController *vc = [[XFMyInviteController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
