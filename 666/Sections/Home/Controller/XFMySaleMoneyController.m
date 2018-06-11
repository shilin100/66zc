//
//  XFMySaleMoneyController.m
//  666
//
//  Created by xiaofan on 2017/10/18.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFMySaleMoneyController.h"
#import "XFScoreDetailController.h"
#import "XFMySaleMoneyGetController.h"

@interface XFMySaleMoneyController ()
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;
@property (weak, nonatomic) IBOutlet UILabel *getLbl;
@property (weak, nonatomic) IBOutlet UILabel *inGetLbl;

@property (weak, nonatomic) IBOutlet UIImageView *bgImv;


@end

@implementation XFMySaleMoneyController

#pragma mark - SYS
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"佣金";
    self.bgImv.clipsToBounds=YES;
    
    _totalLbl.text=[NSString stringWithFormat:@"%.2f",[_totalMoney floatValue]];
    _getLbl.text=[NSString stringWithFormat:@"%.2f",[_ytxMoney floatValue]];
    _inGetLbl.text=[NSString stringWithFormat:@"%.2f",[_txzMoney floatValue]];
    
    
}
- (IBAction)moneyDetailBtnClick {
    XFScoreDetailController *vc = [[XFScoreDetailController alloc] init];
    vc.indentifer = @"money";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)getMoneyBtnClick {
    XFMySaleMoneyGetController *vc = [[XFMySaleMoneyGetController alloc] init];
//    vc.totalMoney=_totalMoney;
//    vc.txzMoney=_txzMoney;
    vc.isCash = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)introduceBtnClick {
    [SVProgressHUD show];
    NSMutableDictionary *params = [XFTool baseParams];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/My/user_recomm",BASE_URL] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"status"] intValue] == 1) {
            NSString* urlStr = responseObject[@"url"];
            XFWebViewController* webViewController = [UIStoryboard storyboardWithName:@"XFWebViewController" bundle:nil].instantiateInitialViewController;
            webViewController.urlString = urlStr;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
//        NSLog(@"<<%@",error);
    }];
}


@end
